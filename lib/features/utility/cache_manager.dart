// keşleme işlemi için bir katman görevi görür ve paket bağımlılıklarını azaltır
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

import '../model/game_model.dart';

final class CacheManager {
  CacheManager._();
  static final CacheManager db = CacheManager._();

  init() async {
    await Hive.initFlutter("localdatabase");
    Hive.registerAdapter(GameModelAdapter());
    await Hive.openBox<GameModel>("gamebox");
  }

  Future<void> putAll(GameModel gameModel) async {
    print("1 gameModel.teamName1 ${gameModel.teamName1}");
    Hive.box<GameModel>("gamebox").clear().then((e) async {
      GameModel? gameModel2 = Hive.box<GameModel>("gamebox").get("game");
      if (gameModel2 is GameModel) {
        print("2 gameModel.teamName1 ${gameModel2.teamName1}");
      } else {
        print("2 gameModel.teamName1 null");
      }
      await Hive.box<GameModel>("gamebox").putAll({"game": gameModel});
      GameModel? gameModel3 = Hive.box<GameModel>("gamebox").get("game");
      if (gameModel3 is GameModel) {
        print("3 gameModel.teamName1 ${gameModel3.teamName1}");
      } else {
        print("3 gameModel.teamName1 null");
      }
    });
  }

  GameModel? getGameModel() {
    return Hive.box<GameModel>("gamebox").get("game");
  }

  clearGameModel() async {
    GameModel gameModel = GameModel(
        teamName1: ConstantString.team1,
        teamName2: ConstantString.team2,
        pass: 3,
        time: 60,
        point: 20);
    await Hive.box<GameModel>("gamebox").putAll({"game": gameModel});
  }
}
