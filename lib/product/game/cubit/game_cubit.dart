import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabumium/features/utility/enum/enum_general_state.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/enum/enum_teams.dart';
import '../model/tabu_model.dart';
import '../service/IGameService.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final IGameService service;
  final String categoryId;
  final int time;
  final int winPoint;
  final int pass;
  GameCubit({
    required this.service,
    required this.categoryId,
    required this.time,
    required this.winPoint,
    required this.pass,
  }) : super(GameState());

  Timer? _timer;
  List<TabuModel> tabuModelList = [];
  int teamPoint1 = 0;
  int teamPoint2 = 0;

  int? pausedSeconds;

  Random random = Random();

  Future<void> startGame() async {
    // fetchTabuData();
    try {
      final data = await service.getWordList(0, categoryId);

      if (data.data != null && (data.data ?? []).isNotEmpty) {
        List<TabuModel> wordList = data.data ?? [];
        tabuModelList.addAll(wordList);
        emit(state.copyWith(page: 1));
        selectTabuModel();
        emit(state.copyWith(
            status: EnumGeneralStateStatus.completed,
            gameStatus: GameStatus.game,
            remainingSeconds: time,
            passNum: pass,
            remainingPassNum: pass));
        startTimer();
      } else {
        emit(state.copyWith(status: EnumGeneralStateStatus.failure));
      }
    } on NetworkException catch (e) {
      emit(state.copyWith(status: EnumGeneralStateStatus.failure));
      MyLog("cubit NetworkException $e");
    } catch (e) {
      emit(state.copyWith(status: EnumGeneralStateStatus.failure));
      MyLog("cubit catch $e");
    }
  }

  Future<void> fetchWordList() async {
    try {
      final data = await service.getWordList(state.page + 1, categoryId);

      if (data.data != null) {
        List<TabuModel> wordList = data.data ?? [];
        tabuModelList.addAll(wordList);
        emit(state.copyWith(page: state.page + 1));
      }
    } on NetworkException catch (e) {
      MyLog("cubit NetworkException $e");
    } catch (e) {
      MyLog("cubit catch $e");
    }
  }

  // void fetchTabuData() async {
  //   await fetchWordList();
  //   selectTabuModel();
  //   emit(state.copyWith(
  //       status: Status.game,
  //       remainingSeconds: time,
  //       passNum: pass,
  //       remainingPassNum: pass));
  //   startTimer();
  // }

  void selectTabuModel() {
    if ((teamPoint1 < winPoint && teamPoint2 < winPoint) &&
        tabuModelList.isNotEmpty) {
      if (tabuModelList.length < 3) {
        fetchWordList();
      }
      TabuModel tabuModel = tabuModelList[0];
      emit(state.copyWith(tabuModel: tabuModel));
      tabuModelList.removeAt(0);
    } else if (tabuModelList.isEmpty) {
      emit(state.copyWith(
          gameStatus: GameStatus.gamefinish,
          winTeam: teamPoint1 > teamPoint2
              ? Teams.team1
              : teamPoint1 < teamPoint2
                  ? Teams.team2
                  : null));
      close();
    }
  }

  changeTeam() {
    switch (state.currentTeam) {
      case Teams.team1:
        emit(state.copyWith(
          currentTeam: Teams.team2,
          gameStatus: GameStatus.game,
          remainingPassNum: pass,
        ));
        selectTabuModel();
        resetTimer();
        break;
      default:
        emit(state.copyWith(
          currentTeam: Teams.team1,
          gameStatus: GameStatus.game,
          remainingPassNum: pass,
        ));
        selectTabuModel();
        resetTimer();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        emit(state.copyWith(
            remainingSeconds:
                state.remainingSeconds - 1)); // Yeni durumu Bloc'a bildir
      } else {
        timer.cancel();
        emit(state.copyWith(gameStatus: GameStatus.timerFinish));
      }
    });
  }

  void resetTimer() {
    // _timer?.cancel();
    emit(state.copyWith(remainingSeconds: time));
    startTimer();
  }

  void isExit() {
    emit(state.copyWith(gameStatus: GameStatus.gameExit));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  stopAndStartTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      pausedSeconds = state.remainingSeconds; // Kalan süreyi kaydet
      emit(state.copyWith(gameStatus: GameStatus.gamePause));
    } else if ((state.gameStatus == GameStatus.gamePause ||
            state.gameStatus == GameStatus.gameExit) &&
        pausedSeconds != null) {
      emit(state.copyWith(
          remainingSeconds: pausedSeconds!, gameStatus: GameStatus.game));
      startTimer();
    }
  }

  selectTrue(
    BuildContext context,
  ) {
    Teams currentTeam = state.currentTeam;
    TeamManager(currentTeam).onTap(context, 1);
    selectTabuModel();
  }

  selectFalse(
    BuildContext context,
  ) {
    Teams currentTeam = state.currentTeam;
    TeamManager(currentTeam).onTap(context, -1);
    selectTabuModel();
  }

  selectPass() {
    // Teams currentTeam = state.currentTeam;
    // currentTeam.onTap(context, -1);
    int pass = state.remainingPassNum;
    if (pass - 1 >= 0) {
      emit(state.copyWith(remainingPassNum: pass - 1));
      selectTabuModel();
    }
  }

  void addTeamPoint1(int point) {
    debugPrint("addTeamPoint1");
    if (teamPoint1 > -99) {
      teamPoint1 += point;
      if (teamPoint1 >= winPoint) {
        emit(state.copyWith(
            gameStatus: GameStatus.gamefinish,
            winTeam: Teams.team1,
            teamPoint1: teamPoint1));
        _timer?.cancel();
      } else {
        emit(state.copyWith(teamPoint1: teamPoint1));
      }
    }
  }

  void addTeamPoint2(int point) {
    if (teamPoint2 > -99) {
      teamPoint2 += point;
      if (teamPoint2 >= winPoint) {
        emit(state.copyWith(
            gameStatus: GameStatus.gamefinish,
            winTeam: Teams.team2,
            teamPoint2: teamPoint2));
        _timer?.cancel();
      } else {
        emit(state.copyWith(teamPoint2: teamPoint2));
      }
    }
  }

  clear() {
    _timer = null;
    if (!isClosed) {
      tabuModelList = [];
      teamPoint1 = 0;
      teamPoint2 = 0;
      pausedSeconds = null;
      emit(state.copyWith(
        status: EnumGeneralStateStatus.loading,
        remainingSeconds: 0,
        tabuModel: null,
        currentTeam: Teams.team1,
        winTeam: null,
        teamPoint1: 0,
        teamPoint2: 0,
        gameStatus: GameStatus.game,
        stopTime: false,
        remainingPassNum: 0,
        passNum: 0,
        page: 1,
      ));
      startGame();
    }
  }
}
