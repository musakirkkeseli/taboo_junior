import 'dart:async';

import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';

part 'solo_game_state.dart';

class SoloGameCubit extends BaseCubit<SoloGameState> {
  final String word;
  SoloGameCubit(this.word) : super(SoloGameState(word: word));

  Timer? _timer;
  int? pausedSeconds;

  startSoloGame() {
    MyLog.debug('Solo oyun başladı: $word');
    safeEmit(state.copyWith(remainingSeconds: 60));
    startTimer();
  }

  stopAndStartTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      pausedSeconds = state.remainingSeconds; // Kalan süreyi kaydet
      safeEmit(state.copyWith(soloGameStatus: SoloGameStatus.gamePause));
    } else if ((state.soloGameStatus == SoloGameStatus.gamePause ||
            state.soloGameStatus == SoloGameStatus.gameExit) &&
        pausedSeconds != null) {
      safeEmit(state.copyWith(
          remainingSeconds: pausedSeconds!,
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
}
