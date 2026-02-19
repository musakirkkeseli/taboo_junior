import 'dart:async';

import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../solo_map/model/solo_game_model.dart';

part 'solo_game_state.dart';

class SoloGameCubit extends BaseCubit<SoloGameState> {
  final List<SoloGameWord> words;
  SoloGameCubit(this.words) : super(SoloGameState());

  Timer? _timer;
  int? pausedSeconds;

  void startSoloGame() {
    if (words.isNotEmpty) {
      SoloGameWord soloGameWord = words.first;
      final String word = soloGameWord.word ?? "";
      List<String> clues = soloGameWord.clues ?? [""];
      final String jokerClue = soloGameWord.jokerClue ?? "";
      MyLog.debug('Solo oyun başladı: $word');
      safeEmit(state.copyWith(
          remainingSeconds: 90,
          totalSeconds: 90,
          word: word,
          wordCount: words.length,
          clues1: clues.length > 3 ? clues.sublist(0, 3) : clues,
          clues2: clues.length > 3 ? clues.sublist(3) : [],
          jokerClue: jokerClue));
      startTimer();
    }
  }

  void nextWord() {
    if ((state.wordIndex + 1) >= state.wordCount) {
      safeEmit(state.copyWith(soloGameStatus: SoloGameStatus.gamefinish));
      _timer?.cancel();
    } else {
      if (_timer != null && _timer!.isActive) {
        _timer?.cancel();
        pausedSeconds = state.remainingSeconds;
      }
      final nextIndex = state.wordIndex + 1;
      SoloGameWord soloGameWord = words[nextIndex - 1];
      final String word = soloGameWord.word ?? "";
      final String jokerClue = soloGameWord.jokerClue ?? "";
      List<String> clues = soloGameWord.clues ?? [""];
      MyLog.debug('Sonraki kelime: $word');
      safeEmit(state.copyWith(
          wordIndex: nextIndex,
          word: word,
          jokerClue: jokerClue,
          clues1: clues.length > 3 ? clues.sublist(0, 3) : clues,
          clues2: clues.length > 3 ? clues.sublist(3) : [],
          isJokerUsed: false));
    }
  }

  void startTimeForNextWord() {
    safeEmit(state.copyWith(remainingSeconds: pausedSeconds ?? 0));
    startTimer();
  }

  void stopAndStartTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      pausedSeconds = state.remainingSeconds; // Kalan süreyi kaydet
      safeEmit(state.copyWith(soloGameStatus: SoloGameStatus.gamePause));
    } else if ((state.soloGameStatus == SoloGameStatus.gamePause ||
            state.soloGameStatus == SoloGameStatus.gameExit) &&
        pausedSeconds != null) {
      safeEmit(state.copyWith(
          remainingSeconds: pausedSeconds ?? 0,
          soloGameStatus: SoloGameStatus.game));
      startTimer();
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
        safeEmit(state.copyWith(soloGameStatus: SoloGameStatus.timerFinish));
      }
    });
  }

  void addTenSeconds() {
    safeEmit(state.copyWith(remainingSeconds: state.remainingSeconds + 10));
  }

  void passWord() {
    nextWord();
  }

  void useTimeJoker() {
    safeEmit(state.copyWith(
      timeJokerCount: state.timeJokerCount + 1,
      totalSeconds: state.totalSeconds + 10,
    ));
    addTenSeconds();
  }

  void usePassJoker() {
    safeEmit(state.copyWith(passJokerCount: state.passJokerCount + 1));
    passWord();
  }

  void useLetterJoker() {
    safeEmit(state.copyWith(letterJokerCount: state.letterJokerCount + 1));
  }

  void useHintJoker() {
    safeEmit(state.copyWith(
        hintJokerCount: state.hintJokerCount + 1, isJokerUsed: true));
  }
}
