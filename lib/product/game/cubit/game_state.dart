part of 'game_cubit.dart';

enum Status {
  init,
  game,
  timerFinish,
  gamefinish,
}

class GameState {
  final int remainingSeconds;
  final TabuModel? tabuModel;
  final Teams currentTeam;
  final Teams? winTeam;
  final int teamPoint1;
  final int teamPoint2;
  final Status status;
  final bool stopTime;
  final bool isPaused;
  final int passNum;
  final int remainingPassNum;

  GameState(
      {this.remainingSeconds = 0,
      this.tabuModel,
      this.currentTeam = Teams.team1,
      this.winTeam,
      this.teamPoint1 = 0,
      this.teamPoint2 = 0,
      this.status = Status.init,
      this.stopTime = false,
      this.isPaused = false,
      this.passNum = 0,
      this.remainingPassNum = 0});

  GameState copyWith({
    int? remainingSeconds,
    TabuModel? tabuModel,
    Teams? currentTeam,
    Teams? winTeam,
    int? teamPoint1,
    int? teamPoint2,
    Status? status,
    bool? stopTime,
    bool? isPaused,
    int? passNum,
    int? remainingPassNum,
  }) {
    return GameState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      tabuModel: tabuModel ?? this.tabuModel,
      currentTeam: currentTeam ?? this.currentTeam,
      winTeam: winTeam ?? this.winTeam,
      teamPoint1: teamPoint1 ?? this.teamPoint1,
      teamPoint2: teamPoint2 ?? this.teamPoint2,
      status: status ?? this.status,
      stopTime: stopTime ?? this.stopTime,
      isPaused: isPaused ?? this.isPaused,
      passNum: passNum ?? this.passNum,
      remainingPassNum: remainingPassNum ?? this.remainingPassNum,
    );
  }
}
