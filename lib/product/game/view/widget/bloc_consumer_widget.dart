import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tabumium/core/utility/logger_service.dart';

import '../../../../core/utility/http_service.dart';
import '../../../../features/model/game_model.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_appbar.dart';
import '../../../../features/utility/enum/enum_general_state.dart';
import '../../../../features/utility/enum/enum_sound.dart';
import '../../../../features/utility/enum/enum_teams.dart';
import '../../../../features/utility/sound_manager.dart';
import '../../../../features/widget/banner_ad_widget.dart';
import '../../../../features/widget/custom_appbar_widget.dart';
import '../../cubit/game_cubit.dart';
import '../../service/game_service.dart';
import 'game_body.dart';
import 'win_screen_widget.dart';

class BlocConsumerWidget extends StatefulWidget {
  final GameModel gameModel;
  final String categoryId;
  const BlocConsumerWidget(
      {super.key, required this.gameModel, required this.categoryId});

  @override
  State<BlocConsumerWidget> createState() => _BlocConsumerWidgetState();
}

class _BlocConsumerWidgetState extends State<BlocConsumerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (context) => GameCubit(
          service: GameService(HttpService()),
          categoryId: widget.categoryId,
          pass: widget.gameModel.pass ?? 3,
          // time: 3,
          time: widget.gameModel.time ?? 60,
          winPoint: widget.gameModel.point ?? 20)
        ..startGame(),
      child: BlocConsumer<GameCubit, GameState>(
        listenWhen: (previous, current) =>
            previous.gameStatus != current.gameStatus,
        listener: (context, state) {
          switch (state.gameStatus) {
            case GameStatus.timerFinish:
              Navigator.of(context)
                  .push(RawDialogRoute(
                      pageBuilder: (_, animation, secondaryAnimation) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: MediaQuery.sizeOf(context).height,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              ConstantString.nextGameBg),
                                          fit: BoxFit.fitWidth),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                              top: 14,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFFFFF97F),
                                                Color(0xFFFBCD38),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                          ),
                                          child: Text(
                                            ConstantString.gameOrder,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: ConstColor
                                                      .customTextColor,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height:
                                              MediaQuery.sizeOf(context).width *
                                                      .28 -
                                                  5,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      state.currentTeam ==
                                                              Teams.team1
                                                          ? ConstantString
                                                              .nextGameTeam1Bg
                                                          : ConstantString
                                                              .nextGameTeam2Bg),
                                                  fit: BoxFit.fitWidth)),
                                          child: Text(
                                            nextTeamName(state.currentTeam),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  color: state.currentTeam
                                                      .teamTitleColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          )))
                  .then((_) {
                context.read<GameCubit>().changeTeam();
              });
              break;
            case GameStatus.gamefinish:
              if (state.notHasInternet) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => StatefulBuilder(
                      builder: (statefulContext, setState) {
                        return AlertDialog(
                          backgroundColor: ConstColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            'İnternet Bağlantısı Kesildi',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: ConstColor.textColor),
                            textAlign: TextAlign.center,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'İnternet bağlantınız kesildiği için oyuna devam edilemiyor. İnternet bağlantınızı sağlayıp oyuna kaldığınız yerden devam edebilirsiniz.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: ConstColor.textColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(
                                'Vazgeç',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: ConstColor.textColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                MyLog.debug("Devam Et butonuna basıldı");
                                final connectivityResult =
                                    await Connectivity().checkConnectivity();
                                final hasInternet = !connectivityResult
                                    .contains(ConnectivityResult.none);

                                if (!hasInternet) {
                                  MyLog.debug("İnternet bağlantısı hala yok");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'İnternet bağlantısı hala yok. Lütfen internet bağlantınızı kontrol edin.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red[700],
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  MyLog.debug("İnternet bağlantısı var");
                                  Navigator.of(dialogContext).pop();
                                  await context
                                      .read<GameCubit>()
                                      .continueGameAfterInternet();
                                }
                              },
                              child: Text(
                                'Devam Et',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: ConstColor.textColor),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ).then((_) {
                    context.read<GameCubit>().continueGameClosed();
                  });
                });
              }
            default:
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(state.gameStatus == GameStatus.gamefinish
                        ? ConstantString.winnerBg
                        : ConstantString.gameBg),
                    fit: BoxFit.fill)),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Scaffold(
              body: Column(
                children: [
                  _appbar(state),
                  Expanded(child: _body(state)),
                  BannerAdWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _appbar(GameState state) {
    switch (state.gameStatus) {
      case GameStatus.gamefinish:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.winnerTeam,
        );
      case GameStatus.gamePause:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.pauseGame,
        );
      case GameStatus.gameExit:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.exitGame,
        );
      default:
        double _t = timeLoading(state.remainingSeconds).clamp(0.0, 1.0);

        return LayoutBuilder(builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double rx = w * 2.5 / 3.3;
          final double ry = MediaQuery.paddingOf(context).top +
              MediaQuery.sizeOf(context).width * .200;
          return ClipPath(
            clipper: _HalfEllipseClipper(rx: rx, ry: ry),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, _t, _t, 1.0],
                      colors: [
                        _t == 0 ? Colors.black : Colors.green,
                        _t == 0 ? Colors.black : Colors.green,
                        Colors.black,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ConstantString.appbarLight),
                            fit: BoxFit.fill)),
                    width: w,
                    height: ry,
                    padding:
                        EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                    child: Builder(builder: (context) {
                      final int minutes = state.remainingSeconds ~/ 60;
                      final int secs = state.remainingSeconds % 60;
                      final String timeString =
                          '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${ConstantString.remainingTime}\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ConstColor.textColor),
                            ),
                            TextSpan(
                              text: timeString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: ConstColor.textColor),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Visibility(
                  visible: state.remainingSeconds == 0 ? false : true,
                  child: Positioned(
                    left: 20,
                    top: MediaQuery.paddingOf(context).top + 10,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffC600A5),
                        border: Border.all(
                          color: Color(0xFF25C1FF),
                          width: 3,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          SoundManager()
                              .playVibrationAndClick(sound: EnumSound.stopTime);
                          context.read<GameCubit>().stopAndStartTimer();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: MediaQuery.paddingOf(context).top + 10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff0069BF),
                      border: Border.all(
                        color: Color(0xFF25C1FF),
                        width: 3,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (state.status == EnumGeneralStateStatus.failure) {
                          context.read<GameCubit>().stopAndStartTimer();
                          context.read<GameCubit>().close();
                          Navigator.of(context).pop();
                        } else {
                          SoundManager()
                              .playVibrationAndClick(sound: EnumSound.stopTime);
                          context.read<GameCubit>().stopAndStartTimer();
                          context.read<GameCubit>().isExit();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    }
  }

  _body(GameState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      case EnumGeneralStateStatus.completed:
        return _gameViews(state);
      default:
        return Center(
          child: Text(
            state.errorMessage ?? ConstantString.wordsRefreshing,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: ConstColor.white),
          ),
        );
    }
  }

  _gameViews(GameState state) {
    switch (state.gameStatus) {
      case GameStatus.gamefinish:
        return WinScreenWidget(
          state: state,
        );
      default:
        return TabuBody(
          state: state,
          pass: widget.gameModel.pass ?? 0,
          remainingPassNum: state.remainingPassNum,
        );
    }
  }

  double timeLoading(int seconds) {
    return (((widget.gameModel.time ?? 60) - seconds) /
        (widget.gameModel.time ?? 60));
  }

  String nextTeamName(Teams currentTeam) {
    String nextTeamName = currentTeam == Teams.team1
        ? TeamManager(Teams.team2).nameValue
        : TeamManager(Teams.team1).nameValue;
    return nextTeamName;
  }
}

class _HalfEllipseClipper extends CustomClipper<Path> {
  final double rx;
  final double ry;

  const _HalfEllipseClipper({required this.rx, required this.ry});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final Rect ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, 0),
      width: rx * 2,
      height: ry * 2,
    );
    path.addOval(ovalRect);
    return path;
  }

  @override
  bool shouldReclip(covariant _HalfEllipseClipper oldClipper) {
    return oldClipper.rx != rx || oldClipper.ry != ry;
  }
}
