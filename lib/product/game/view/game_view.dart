import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/model/game_model.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_categories.dart';
import '../../../features/utility/enum/enum_sound.dart';
import '../../../features/utility/enum/enum_teams.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../cubit/game_cubit.dart';
import 'widget/game_body.dart';
import 'widget/win_screen_widget.dart';

class GameView extends StatefulWidget {
  final GameModel gameModel;
  final Categories category;
  const GameView({super.key, required this.gameModel, required this.category});

  @override
  State<GameView> createState() => _GameViewState();
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

class _GameViewState extends State<GameView> {
  // GameModel? gameModel;
  @override
  void initState() {
    super.initState();
    // gameModel = CacheManager.db.getGameModel();
    // if (gameModel == null) {
    //   CacheManager.db.clearGameModel();
    // }
    SoundManager().stopBackground();
  }

  @override
  void dispose() {
    super.dispose();
    SoundManager().playBackground();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (context) => GameCubit(
          category: widget.category,
          pass: widget.gameModel.pass ?? 3,
          // time: 3,
          time: widget.gameModel.time ?? 60,
          winPoint: widget.gameModel.point ?? 20)
        ..startGame(),
      child: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.timerFinish:
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
            default:
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(state.status == Status.gamefinish
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _appbar(GameState state) {
    switch (state.status) {
      case Status.gamefinish:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.winnerTeam,
        );
      case Status.gamePause:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.pauseGame,
        );
      case Status.gameExit:
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
                        SoundManager()
                            .playVibrationAndClick(sound: EnumSound.stopTime);
                        context.read<GameCubit>().stopAndStartTimer();
                        context.read<GameCubit>().isExit();
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
      case Status.init:
        return Center(
          child: CircularProgressIndicator(),
        );
      case Status.gamefinish:
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

  String nextTeamName(Teams currentTeam) {
    String nextTeamName = currentTeam == Teams.team1
        ? TeamManager(Teams.team2).nameValue
        : TeamManager(Teams.team1).nameValue;
    return nextTeamName;
  }

  double timeLoading(int seconds) {
    return (((widget.gameModel.time ?? 60) - seconds) /
        (widget.gameModel.time ?? 60));
  }
}
