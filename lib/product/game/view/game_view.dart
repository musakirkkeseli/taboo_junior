import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_app/product/game/cubit/game_cubit.dart';
import 'package:tabu_app/features/utility/enum/enum_teams.dart';

import '../../../features/model/game_model.dart';
import '../../../features/utility/cache_manager.dart';
import 'widget/game_body.dart';
import 'widget/win_screen_widget.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  GameModel? gameModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameModel = CacheManager.db.getGameModel();
    if (gameModel == null) {
      CacheManager.db.clearGameModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: BlocProvider(
          create: (context) => GameCubit(
              pass: gameModel!.pass ?? 3,
              time: gameModel!.time ?? 60,
              winPoint: gameModel!.point ?? 20)
            ..startGame(),
          child: BlocConsumer<GameCubit, GameState>(
            listener: (context, state) {
              switch (state.status) {
                case Status.timerFinish:
                  showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: Color(0xffA31D1D),
                          title: Text(
                            "Süre Bitti",
                            style: TextStyle(
                                color: Color(0xffE5D0AC),
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            nextTeamName(state.currentTeam),
                            style: TextStyle(
                                color: Color(0xffE5D0AC),
                                fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.read<GameCubit>().changeTeam();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Süreyi Başlat",
                                  style: TextStyle(
                                      color: Color(0xffE5D0AC),
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        );
                      });
                  break;
                default:
              }
            },
            builder: (context, state) {
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
                    pass: gameModel!.pass ?? 0,
                  );
              }
            },
          ),
        ),
      )),
    );
  }

  String nextTeamName(Teams currentTeam) {
    String nextTeamName = currentTeam == Teams.team1
        ? TeamManager(Teams.team2).nameValue
        : TeamManager(Teams.team1).nameValue;
    return "$nextTeamName hazır olduğunda süreyi başlatabilir";
  }
}
