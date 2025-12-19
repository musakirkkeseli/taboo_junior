part of 'game_cubit.dart';

enum GameStatus { game, gamePause, timerFinish, gamefinish, gameExit }

class GameState {
  final EnumGeneralStateStatus status;
  final int remainingSeconds;
  final TabuModel? tabuModel;
  final Teams currentTeam;
  final Teams? winTeam;
  final int teamPoint1;
  final int teamPoint2;
  final GameStatus gameStatus;
  final bool stopTime;
  final int passNum;
  final int remainingPassNum;
  final int page;

  GameState(
      {this.status = EnumGeneralStateStatus.loading,
      this.remainingSeconds = 0,
      this.tabuModel,
      this.currentTeam = Teams.team1,
      this.winTeam,
      this.teamPoint1 = 0,
      this.teamPoint2 = 0,
      this.gameStatus = GameStatus.game,
      this.stopTime = false,
      this.passNum = 0,
      this.remainingPassNum = 0,
      this.page = 0});

  GameState copyWith({
    EnumGeneralStateStatus? status,
    int? remainingSeconds,
    TabuModel? tabuModel,
    Teams? currentTeam,
    Teams? winTeam,
    int? teamPoint1,
    int? teamPoint2,
    GameStatus? gameStatus,
    bool? stopTime,
    int? passNum,
    int? remainingPassNum,
    int? page,
  }) {
    return GameState(
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      tabuModel: tabuModel ?? this.tabuModel,
      currentTeam: currentTeam ?? this.currentTeam,
      winTeam: winTeam ?? this.winTeam,
      teamPoint1: teamPoint1 ?? this.teamPoint1,
      teamPoint2: teamPoint2 ?? this.teamPoint2,
      gameStatus: gameStatus ?? this.gameStatus,
      stopTime: stopTime ?? this.stopTime,
      passNum: passNum ?? this.passNum,
      remainingPassNum: remainingPassNum ?? this.remainingPassNum,
      page: page ?? this.page,
    );
  }
}
