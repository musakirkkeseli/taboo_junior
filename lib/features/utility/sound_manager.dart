import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

import 'const/constant_string.dart';
import 'enum/enum_sound.dart';

class SoundManager {
  SoundManager._internal();
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  final AudioPlayer _bgPlayer = AudioPlayer(); // arka plan
  final AudioPlayer _sfxPlayer = AudioPlayer(); // efekt (tıklama vs.)

  bool _sfxOpen = true;
  bool _musicOpen = true;
  bool _vibration = true;

  static final AudioContext _gameAudioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  Future<void> init(
      {bool musicOpen = true,
      bool sfxOpen = true,
      bool vibration = true}) async {
    _musicOpen = musicOpen;
    _sfxOpen = sfxOpen;
    _vibration = vibration;

    // Her iki player da aynı context ile çalışsın
    await _bgPlayer.setAudioContext(_gameAudioContext);
    await _sfxPlayer.setAudioContext(_gameAudioContext);

    // --- Arka plan müziği ---
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setSource(AssetSource(ConstantString.bgMusic));
    await _bgPlayer.setVolume(0.3);

    // --- Tıklama sesi (PRELOAD) ---
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setSource(AssetSource(ConstantString.clickSound));
    // lowLatency MODU YOK -> default mod
  }

  Future<void> playBackground() async {
    if (!_musicOpen) return;
    await _bgPlayer.resume();
  }

  Future<void> stopBackground() async {
    await _bgPlayer.stop();
  }

  void changeMusicOpen(bool isOpen) {
    _musicOpen = isOpen;
    if (isOpen) {
      playBackground();
    } else {
      stopBackground();
    }
  }

  void changeVibration(bool isOpen) {
    _vibration = isOpen;
    if (isOpen) {
      playVibration();
    }
  }

  Future<void> playVibration() async {
    if (!_vibration) return;
    await Vibration.cancel();
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(preset: VibrationPreset.singleShortBuzz);
    }
  }

  void changeSfxOpen(bool isOpen) {
    _sfxOpen = isOpen;
    if (isOpen) {
      playSound(EnumSound.click);
    }
  }

  Future<void> playSound(EnumSound sound) async {
    if (!_sfxOpen) return;

    AssetSource assetSource = AssetSource(sound.soundPath);
    try {
      await _sfxPlayer.play(
        assetSource,
        volume: 1.0,
      );
      await _sfxPlayer.stop();
      await _sfxPlayer.seek(Duration.zero);
      await _sfxPlayer.resume();
    } catch (_) {
    }
  }

  void playVibrationAndClick({EnumSound sound = EnumSound.click}) {
    playVibration();
    playSound(sound);
  }

  Future<void> dispose() async {
    await _bgPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
