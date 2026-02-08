part of 'solo_game_cubit.dart';

enum SoloGameStatus { game, gamePause, timerFinish, gamefinish, gameExit }

class SoloGameState {
  final SoloGameStatus soloGameStatus;
  final String word;
  final int remainingSeconds;

  SoloGameState({
    required this.word,
    this.soloGameStatus = SoloGameStatus.game,
    this.remainingSeconds = 0,
  });

  SoloGameState copyWith({
    String? word,
    SoloGameStatus? soloGameStatus,
    int? remainingSeconds,
  }) {
    return SoloGameState(
      word: word ?? this.word,
      soloGameStatus: soloGameStatus ?? this.soloGameStatus,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}
