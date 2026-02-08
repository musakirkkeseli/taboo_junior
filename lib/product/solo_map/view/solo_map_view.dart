import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../../../features/widget/banner_ad_widget.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../solo_game/view/solo_game_view.dart';
import '../cubit/solo_map_cubit.dart';
import '../model/solo_game_model.dart';
import 'widget/custom_level_button.dart';

class SoloMapView extends StatefulWidget {
  const SoloMapView({super.key});

  @override
  State<SoloMapView> createState() => _SoloMapViewState();
}

class _SoloMapViewState extends State<SoloMapView> {
  final GlobalKey currentLevelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SoloMapCubit>(
      create: (context) => SoloMapCubit()..fetchSoloMapData(),
      child: BlocConsumer<SoloMapCubit, SoloMapState>(
        listener: (context, state) {
          if (state.status == EnumGeneralStateStatus.completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentLevelKey.currentContext != null) {
                Scrollable.ensureVisible(
                  currentLevelKey.currentContext!,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: 0.5,
                );
              }
            });
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ConstantString.soloMapBg),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Column(
                    children: [
                      CustomAppbarWidget(
                        appbarType: EnumCustomAppbarType.soloGameMap,
                      ),
                      Expanded(child: body(context, state)),
                    ],
                  ),
                  Positioned(
                    width: MediaQuery.sizeOf(context).width,
                    bottom: MediaQuery.paddingOf(context).bottom,
                    child: floatActionButton(context, state),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  body(BuildContext context, SoloMapState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return Center(child: CircularProgressIndicator());
      case EnumGeneralStateStatus.completed:
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (state.soloGameList ?? []).length,
                      itemBuilder: (context, index) {
                        final soloGameList = (state.soloGameList ?? []);
                        final isCurrentLevel =
                            soloGameList[index].id == state.soloGame?.id;
                        return Column(
                          key: isCurrentLevel ? currentLevelKey : null,
                          children: [
                            index == 0
                                ? SizedBox(
                                    height: 30,
                                  )
                                : Container(
                                    width: 10,
                                    height: 57,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                          Color(0xff9EBBFF),
                                          Color(0xffFFFFFF)
                                        ])),
                                  ),
                            CustomLevelButton(
                              level: soloGameList[index],
                              currentLevel: state.soloGame!,
                            ),
                            index == soloGameList.length - 1
                                ? SizedBox(height: 230)
                                : SizedBox.shrink()
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return Center(
          child: Text(
            ConstantString.unexpectedError,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: ConstColor.white),
          ),
        );
    }
  }

  floatActionButton(BuildContext context, SoloMapState state) {
    return Column(
      children: [
        Visibility(
          visible: state.status == EnumGeneralStateStatus.completed,
          child: InkWell(
            onTap: () async {
              if (kDebugMode) {
                SoloGame? soloGame = state.soloGame;
                if (soloGame is SoloGame) {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoloGameView(
                                level: soloGame.id ?? 0,
                                word: soloGame.word ?? "",
                                clues: soloGame.clues ?? [],
                              )));
                  if (result == true) {
                    context.read<SoloMapCubit>().levelUp();
                  }
                }
              }
            },
            child: Container(
                width: MediaQuery.sizeOf(context).width - 140,
                height: (MediaQuery.sizeOf(context).width - 140) * .30,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ConstantString.soloGameButtonBg),
                        fit: BoxFit.fitWidth)),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, -10),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ConstantString.soloPlayIc),
                      Text(
                        ConstantString.soloGame,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: ConstColor.customTextColor,
                                ),
                      )
                    ],
                  ),
                )),
          ),
        ),
        SizedBox(height: 15),
        BannerAdWidget()
      ],
    );
  }
}
