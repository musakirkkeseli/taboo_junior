import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';
import 'package:tabumium/features/utility/enum/enum_teams.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_sound.dart';
import '../../../../features/utility/sound_manager.dart';
import '../../../../features/widget/custom_elevated_button.dart';
import '../../../../features/widget/custom_outlined_button.dart';
import '../../cubit/game_cubit.dart';

class WinScreenWidget extends StatefulWidget {
  final GameState state;
  const WinScreenWidget({super.key, required this.state});

  @override
  State<WinScreenWidget> createState() => _WinScreenWidgetState();
}

class _WinScreenWidgetState extends State<WinScreenWidget> {
  @override
  void initState() {
    super.initState();
    SoundManager().playVibrationAndClick(sound: EnumSound.victory);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ConstantString.nextGameBg),
                    fit: BoxFit.fitWidth),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(ConstantString.winnerImage),
                  // widget.state.winTeam == null
                  //     ? Text(ConstantString.friendshipWon,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyLarge
                  //             ?.copyWith(
                  //               color: ConstColor.white,
                  //             ))
                  //     : Text(
                  //         TeamManager(widget.state.winTeam ?? Teams.team1)
                  //             .nameValue,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .headlineLarge
                  //             ?.copyWith(
                  //               color: ConstColor.white,
                  //             ))
                  Flexible(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(ConstantString.winnerImage),
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    flex: 1,
                    child: widget.state.winTeam == null
                        ? Text(ConstantString.friendshipWon,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: ConstColor.white,
                                    ))
                        : Text(
                            TeamManager(widget.state.winTeam ?? Teams.team1)
                                .nameValue,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: ConstColor.white,
                                )),
                  ),
                ],
              )),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width - 60,
          // height: (MediaQuery.sizeOf(context).width - 60) * .29,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 2, color: Color(0xffB87FFF))),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                  decoration: BoxDecoration(
                      color: Color(0xffB87FFF),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15))),
                  child: Text(
                    ConstantString.score,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ConstColor.scoreTextColor,
                        ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(
                              TeamManager(Teams.team1).nameValue,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            ),
                          ),
                          Text(
                            widget.state.teamPoint1.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(TeamManager(Teams.team2).nameValue,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                          Text(
                            widget.state.teamPoint2.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomElevatedButton(
            maxWidth: MediaQuery.sizeOf(context).width,
            title: ConstantString.newGame,
            onTap: () async {
              final connectivityResult =
                  await Connectivity().checkConnectivity();
              final _hasInternet =
                  !connectivityResult.contains(ConnectivityResult.none);
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
              } else {
                MyLog.debug("Yeni Oyun butonuna basıldı");
                SoundManager().playVibrationAndClick();
                context.read<GameCubit>().clear();
              }
            },
            iconPath: ConstantString.playIc,
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        CustomOutlinedButton(
          title: ConstantString.backToHome,
          onPressed: () {
            SoundManager().playVibrationAndClick();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          maxWidth: MediaQuery.sizeOf(context).width,
          icon: Icons.home,
        ),
        SizedBox(
          height: MediaQuery.paddingOf(context).bottom + 10,
        )
      ],
    );
  }
}
