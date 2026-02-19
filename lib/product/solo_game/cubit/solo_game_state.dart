part of 'solo_game_cubit.dart';

enum SoloGameStatus { game, gamePause, timerFinish, gamefinish, gameExit }

class SoloGameState {
  final SoloGameStatus soloGameStatus;
  final String? word;
  final String? jokerClue;
  final bool isJokerUsed;
  final int remainingSeconds;
  final int totalSeconds; // Toplam süre (joker kullanımıyla artar)
  final int wordCount;
  final int wordIndex;
  final List<String> clues1;
  final List<String> clues2;
  final int timeJokerCount;
  final int passJokerCount;
  final int letterJokerCount;
  final int hintJokerCount;

  SoloGameState({
    this.word,
    this.jokerClue,
    this.isJokerUsed = false,
    this.soloGameStatus = SoloGameStatus.game,
    this.remainingSeconds = 0,
    this.totalSeconds = 90,
    this.wordCount = 0,
    this.wordIndex = 1,
    this.clues1 = const [],
    this.clues2 = const [],
    this.timeJokerCount = 0,
    this.passJokerCount = 0,
    this.letterJokerCount = 0,
    this.hintJokerCount = 0,
  });

  SoloGameState copyWith({
    String? word,
    String? jokerClue,
    bool? isJokerUsed,
    SoloGameStatus? soloGameStatus,
    int? remainingSeconds,
    int? totalSeconds,
    int? wordCount,
    int? wordIndex,
    List<String>? clues1,
    List<String>? clues2,
    int? timeJokerCount,
    int? passJokerCount,
    int? letterJokerCount,
    int? hintJokerCount,
  }) {
    return SoloGameState(
      word: word ?? this.word,
      jokerClue: jokerClue ?? this.jokerClue,
      isJokerUsed: isJokerUsed ?? this.isJokerUsed,
      soloGameStatus: soloGameStatus ?? this.soloGameStatus,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      wordCount: wordCount ?? this.wordCount,
      wordIndex: wordIndex ?? this.wordIndex,
      clues1: clues1 ?? this.clues1,
      clues2: clues2 ?? this.clues2,
      timeJokerCount: timeJokerCount ?? this.timeJokerCount,
      passJokerCount: passJokerCount ?? this.passJokerCount,
      letterJokerCount: letterJokerCount ?? this.letterJokerCount,
      hintJokerCount: hintJokerCount ?? this.hintJokerCount,
    );
  }
}
