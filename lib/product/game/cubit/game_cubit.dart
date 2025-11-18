import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

import '../../../features/utility/enum/enum_teams.dart';
import '../model/tabu_model.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final int time;
  final int winPoint;
  final int pass;
  GameCubit({
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

  void startGame() {
    fetchTabuData();
  }

  void fetchTabuData() async {
    tabuModelList = await loadTabuData();
    selectTabuModel();
    emit(state.copyWith(
        status: Status.game,
        remainingSeconds: time,
        passNum: pass,
        remainingPassNum: pass));
    startTimer();
  }

  void selectTabuModel() {
    if ((teamPoint1 < winPoint && teamPoint2 < winPoint) &&
        tabuModelList.isNotEmpty) {
      int randomNumber = random.nextInt(tabuModelList.length);
      TabuModel tabuModel = tabuModelList[randomNumber];
      emit(state.copyWith(tabuModel: tabuModel));
      tabuModelList.removeAt(randomNumber);
    } else if (tabuModelList.isEmpty) {
      emit(state.copyWith(
          status: Status.gamefinish,
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
          status: Status.game,
          remainingPassNum: pass,
        ));
        selectTabuModel();
        resetTimer();
        break;
      default:
        emit(state.copyWith(
          currentTeam: Teams.team1,
          status: Status.game,
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
        emit(state.copyWith(status: Status.timerFinish));
      }
    });
  }

  void resetTimer() {
    // _timer?.cancel();
    emit(state.copyWith(remainingSeconds: time));
    startTimer();
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
      emit(state.copyWith(isPaused: true));
    } else if (state.isPaused && pausedSeconds != null) {
      emit(state.copyWith(remainingSeconds: pausedSeconds!, isPaused: false));
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
    print("addTeamPoint1");
    teamPoint1 += point;
    if (teamPoint1 >= winPoint) {
      emit(state.copyWith(
          status: Status.gamefinish,
          winTeam: Teams.team1,
          teamPoint1: teamPoint1));
      _timer?.cancel();
    } else {
      emit(state.copyWith(teamPoint1: teamPoint1));
    }
  }

  void addTeamPoint2(int point) {
    teamPoint2 += point;
    if (teamPoint2 >= winPoint) {
      emit(state.copyWith(
          status: Status.gamefinish,
          winTeam: Teams.team2,
          teamPoint2: teamPoint2));
      _timer?.cancel();
    } else {
      emit(state.copyWith(teamPoint2: teamPoint2));
    }
  }

  Future<List<TabuModel>> loadTabuData() async {
    // JSON dosyasını oku
    final String response =
        await rootBundle.loadString(ConstantString.dataWords);

    // JSON'u decode et ve TabuModel listesine dönüştür
    final List<dynamic> data = json.decode(response);
    return data.map((item) => TabuModel.fromJson(item)).toList();
  }

  clear() {
    _timer = null;
    if (!isClosed) {
      tabuModelList = [];
      teamPoint1 = 0;
      teamPoint2 = 0;
      pausedSeconds = null;
      emit(state.copyWith(
        remainingSeconds: 0,
        tabuModel: null,
        currentTeam: Teams.team1,
        winTeam: null,
        teamPoint1: 0,
        teamPoint2: 0,
        status: Status.init,
        stopTime: false,
        isPaused: false,
        remainingPassNum: 0,
        passNum: 0,
      ));
      startGame();
    }
  }
}
