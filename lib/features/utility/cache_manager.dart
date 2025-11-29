import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

import '../model/game_model.dart';

class CacheManager {
  CacheManager._();
  static final CacheManager db = CacheManager._();

  late SharedPreferences _prefs;

  static const _gameKey = 'game';
  static const _soundKey = 'settings_sound';
  static const _musicKey = 'settings_music';
  static const _vibrationKey = 'settings_vibration';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    if (!_prefs.containsKey(_gameKey)) {
      final defaultGame = GameModel(
        teamName1: ConstantString.team1,
        teamName2: ConstantString.team2,
        pass: 3,
        time: 60,
        point: 20,
      );
      saveGameModel(defaultGame);
    }
    // Ensure settings keys exist with sensible defaults
    if (!_prefs.containsKey(_soundKey)) {
      _prefs.setBool(_soundKey, true);
    }
    if (!_prefs.containsKey(_musicKey)) {
      _prefs.setBool(_musicKey, true);
    }
    if (!_prefs.containsKey(_vibrationKey)) {
      _prefs.setBool(_vibrationKey, true);
    }
  }

  GameModel getGameModel() {
    final jsonString = _prefs.getString(_gameKey);
    if (jsonString == null) {
      return GameModel(
        teamName1: ConstantString.team1,
        teamName2: ConstantString.team2,
        pass: 3,
        time: 60,
        point: 20,
      );
    }
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return GameModel.fromJson(map);
  }

  void saveGameModel(GameModel game) {
    final jsonString = jsonEncode(game.toJson());
    _prefs.setString(_gameKey, jsonString);
  }

  void clearGameModel() {
    final defaultGame = GameModel(
      teamName1: ConstantString.team1,
      teamName2: ConstantString.team2,
      pass: 3,
      time: 60,
      point: 20,
    );
    saveGameModel(defaultGame);
  }

  // Settings getters and setters
  bool getSound() => _prefs.getBool(_soundKey) ?? true;
  Future<void> setSound(bool value) async {
    await _prefs.setBool(_soundKey, value);
  }

  bool getMusic() => _prefs.getBool(_musicKey) ?? false;
  Future<void> setMusic(bool value) async {
    await _prefs.setBool(_musicKey, value);
  }

  bool getVibration() => _prefs.getBool(_vibrationKey) ?? true;
  Future<void> setVibration(bool value) async {
    await _prefs.setBool(_vibrationKey, value);
  }
}
