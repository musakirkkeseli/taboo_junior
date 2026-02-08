import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../../../features/utility/enum/enum_teams.dart';
import '../model/tabu_model.dart';
import '../service/IGameService.dart';

part 'game_state.dart';

class GameCubit extends BaseCubit<GameState> {
  final IGameService service;
  final String categoryId;
  final int difficulty;
  final int time;
  final int winPoint;
  final int pass;
  GameCubit({
    required this.service,
    required this.categoryId,
    required this.difficulty,
    required this.time,
    required this.winPoint,
    required this.pass,
  }) : super(GameState());

  Timer? _timer;
  List<TabuModel> tabuModelList = [];
  int teamPoint1 = 0;
  int teamPoint2 = 0;
  bool notHasInternet = false;
  String _difficultyString = '';

  int? pausedSeconds;

  Random random = Random();

  final MyLog _log = MyLog('GameCubit');

  Future<void> startGame() async {
    MyLog.debug("GameCubit startGame called");
    switch (difficulty) {
      case 1:
        _difficultyString = "easy";
        break;
      case 2:
        _difficultyString = "medium";
        break;
      case 3:
        _difficultyString = "hard";
        break;
      case 4:
        _difficultyString = "expert";
        break;
      default:
        _difficultyString = "medium";
    }
    // fetchTabuData();
    // İlk olarak internet bağlantısını kontrol et
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

      if (!hasInternet) {
        _log.d("İnternet bağlantısı yok, oyun başlatılamıyor");
        safeEmit(state.copyWith(
            status: EnumGeneralStateStatus.failure,
            errorMessage: "İnternet bağlantısı yok"));
        return;
      }
    } catch (e) {
      _log.d("İnternet kontrolü başarısız: $e");
      safeEmit(state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: "İnternet kontrolü başarısız"));
      return;
    }

    try {
      final data = await service.getWordList(0, categoryId, _difficultyString);

      if (data.data != null && (data.data ?? []).isNotEmpty) {
        List<TabuModel> wordList = data.data ?? [];
        tabuModelList.addAll(wordList);
        safeEmit(state.copyWith(page: 1));
        selectTabuModel();
        safeEmit(state.copyWith(
            status: EnumGeneralStateStatus.completed,
            gameStatus: GameStatus.game,
            remainingSeconds: time,
            passNum: pass,
            remainingPassNum: pass));
        startTimer();
      } else {
        safeEmit(state.copyWith(status: EnumGeneralStateStatus.failure));
      }
    } on NetworkException catch (e) {
      safeEmit(state.copyWith(status: EnumGeneralStateStatus.failure));
      MyLog("cubit NetworkException $e");
    } catch (e) {
      safeEmit(state.copyWith(status: EnumGeneralStateStatus.failure));
      MyLog("cubit catch $e");
    }
  }

  Future<void> fetchWordList() async {
    try {
      final data = await service.getWordList(
          state.page + 1, categoryId, _difficultyString);

      if (data.data != null) {
        List<TabuModel> wordList = data.data ?? [];
        tabuModelList.addAll(wordList);
        safeEmit(state.copyWith(page: state.page + 1));
      }
    } on NetworkException catch (e) {
      MyLog("cubit NetworkException $e");
    } catch (e) {
      MyLog("cubit catch $e");
    }
  }

  void selectTabuModel() async {
    if ((teamPoint1 < winPoint && teamPoint2 < winPoint) &&
        tabuModelList.isNotEmpty) {
      if (tabuModelList.length < 3) {
        final connectivityResult = await Connectivity().checkConnectivity();
        final hasInternet =
            !connectivityResult.contains(ConnectivityResult.none);

        if (hasInternet) {
          notHasInternet = false;
          fetchWordList();
        } else {
          notHasInternet = true;
          _log.d("İnternet bağlantısı yok, yeni kelimeler yüklenemiyor");
        }
      }
      TabuModel tabuModel = tabuModelList[0];
      safeEmit(state.copyWith(tabuModel: tabuModel));
      tabuModelList.removeAt(0);
    } else if (tabuModelList.isEmpty) {
      safeEmit(state.copyWith(
          gameStatus: GameStatus.gamefinish,
          notHasInternet: notHasInternet &
              ((teamPoint1 < winPoint) & (teamPoint2 < winPoint)),
          winTeam: teamPoint1 > teamPoint2
              ? Teams.team1
              : teamPoint1 < teamPoint2
                  ? Teams.team2
                  : null));
      _timer?.cancel();
    }
  }

  changeTeam() {
    switch (state.currentTeam) {
      case Teams.team1:
        safeEmit(state.copyWith(
          currentTeam: Teams.team2,
          gameStatus: GameStatus.game,
          remainingPassNum: pass,
        ));
        selectTabuModel();
        resetTimer();
        break;
      default:
        safeEmit(state.copyWith(
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
        safeEmit(state.copyWith(
            remainingSeconds:
                state.remainingSeconds - 1)); // Yeni durumu Bloc'a bildir
      } else {
        timer.cancel();
        safeEmit(state.copyWith(gameStatus: GameStatus.timerFinish));
      }
    });
  }

  void resetTimer() {
    safeEmit(state.copyWith(remainingSeconds: time));
    startTimer();
  }

  void isExit() {
    safeEmit(state.copyWith(gameStatus: GameStatus.gameExit));
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
      safeEmit(state.copyWith(gameStatus: GameStatus.gamePause));
    } else if ((state.gameStatus == GameStatus.gamePause ||
            state.gameStatus == GameStatus.gameExit) &&
        pausedSeconds != null) {
      safeEmit(state.copyWith(
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
      safeEmit(state.copyWith(remainingPassNum: pass - 1));
      selectTabuModel();
    }
  }

  void addTeamPoint1(int point) {
    _log.d("addTeamPoint1");
    if (teamPoint1 > -99) {
      teamPoint1 += point;
      if (teamPoint1 >= winPoint) {
        safeEmit(state.copyWith(
            gameStatus: GameStatus.gamefinish,
            notHasInternet: false,
            winTeam: Teams.team1,
            teamPoint1: teamPoint1));
        _timer?.cancel();
      } else {
        safeEmit(state.copyWith(teamPoint1: teamPoint1));
      }
    }
  }

  void addTeamPoint2(int point) {
    if (teamPoint2 > -99) {
      teamPoint2 += point;
      if (teamPoint2 >= winPoint) {
        safeEmit(state.copyWith(
            gameStatus: GameStatus.gamefinish,
            notHasInternet: false,
            winTeam: Teams.team2,
            teamPoint2: teamPoint2));
        _timer?.cancel();
      } else {
        safeEmit(state.copyWith(teamPoint2: teamPoint2));
      }
    }
  }

  clear() {
    MyLog.debug("GameCubit clear called");
    _timer = null;
    MyLog.debug("isClosed $isClosed");
    if (!isClosed) {
      tabuModelList = [];
      teamPoint1 = 0;
      teamPoint2 = 0;
      pausedSeconds = null;
      safeEmit(state.copyWith(
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
        notHasInternet: false,
      ));
      startGame();
    }
  }

  continueGameClosed() {
    notHasInternet = false;
    safeEmit(state.copyWith(notHasInternet: false));
  }

  Future<void> continueGameAfterInternet() async {
    try {
      await fetchWordList();
      safeEmit(state.copyWith(
        gameStatus: GameStatus.game,
        status: EnumGeneralStateStatus.completed,
      ));
      selectTabuModel();
      startTimer();
    } catch (e) {
      _log.d("Oyuna devam edilirken hata: $e");
      safeEmit(state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: "Oyuna devam edilirken hata oluştu"));
    }
  }
}
