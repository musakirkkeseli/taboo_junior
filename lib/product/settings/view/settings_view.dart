import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tabumium/core/utility/logger_service.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

import '../../../features/model/game_model.dart';
import '../../../features/utility/cache_manager.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_slider_type.dart';
import '../../../features/utility/enum/enum_teams.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../../features/widget/custom_elevated_button.dart';
import '../../../features/widget/custom_slider_widget.dart';
import '../../../features/widget/team_name_widget.dart';
import '../../game/view/game_view.dart';
import '../../select_category/mıodel/category_model.dart';

class SettingsView extends StatefulWidget {
  final CategoryModel category;
  const SettingsView({super.key, required this.category});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  GameModel? gameModel;
  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();
  final ValueNotifier<double> passCount = ValueNotifier<double>(3);
  final ValueNotifier<double> timeCount = ValueNotifier<double>(60);
  final ValueNotifier<double> maxPointCount = ValueNotifier<double>(20);
  bool _hasInternet = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    gameModel = CacheManager.db.getGameModel();
    nameController1.text = gameModel!.teamName1 ?? "";
    nameController2.text = gameModel!.teamName2 ?? "";
    passCount.value = (gameModel!.pass ?? 3).toDouble();
    timeCount.value = (gameModel!.time ?? 60).toDouble();
    maxPointCount.value = (gameModel!.point ?? 20).toDouble();
    _checkInitialConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (mounted) {
        setState(() {
          _hasInternet = !result.contains(ConnectivityResult.none);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasInternet = false;
        });
      }
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (mounted) {
      setState(() {
        _hasInternet = !result.contains(ConnectivityResult.none);
      });
    }
  }

  @override
  dispose() {
    _connectivitySubscription?.cancel();
    nameController1.dispose();
    nameController2.dispose();
    passCount.dispose();
    timeCount.dispose();
    maxPointCount.dispose();
    super.dispose();
  }

  List<SliderType> sliderTypeList = SliderType.values;
  List<Teams> teamsTypeList = Teams.values;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ConstantString.soloMapBg), fit: BoxFit.fill)),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbarWidget(
              appbarType: EnumCustomAppbarType.gameSettings,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: formkey,
                        child: Column(
                          children: teamsTypeList.map((e) {
                            return TeamNameWidget(
                              title: e.nameTitleValue,
                              textEditingController: e == Teams.team1
                                  ? nameController1
                                  : nameController2,
                              validator: (value) {
                                if ((value ?? "").isEmpty) {
                                  return ConstantString.notEmptyTeamName;
                                }
                                return null;
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Column(
                        children: sliderTypeList.map((e) {
                          return CustomSliderWidget(
                            title: e.titleValue,
                            max: e.maxValue,
                            min: e.minValue,
                            valueString: e.valueString,
                            value: useValue(e),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: (MediaQuery.sizeOf(context).width - 60) * .293 +
                            MediaQuery.paddingOf(context).bottom +
                            20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: CustomElevatedButton(
            maxWidth: MediaQuery.sizeOf(context).width,
            title: ConstantString.game,
            onTap: () {
              if (!_hasInternet) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'İnternet bağlantınız olmadığı için oyuna başlayamazsınız. Lütfen internet bağlantınızı kontrol edin.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red[700],
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (formkey.currentState!.validate()) {
                formkey.currentState!.save();
                MyLog.debug("save pass ${passCount.value}");
                GameModel gameModel = GameModel(
                    teamName1: nameController1.text,
                    teamName2: nameController2.text,
                    pass: passCount.value.toInt(),
                    time: timeCount.value.toInt(),
                    point: maxPointCount.value.toInt());
                CacheManager.db.saveGameModel(gameModel);
                SoundManager().playVibrationAndClick();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameView(
                              gameModel: gameModel,
                              categoryId: widget.category.id ?? "",
                            )));
              }
            },
            iconPath: ConstantString.playIc,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  ValueNotifier<double> useValue(SliderType e) {
    switch (e) {
      case SliderType.pass:
        return passCount;
      case SliderType.time:
        return timeCount;
      case SliderType.point:
        return maxPointCount;
    }
  }
}
