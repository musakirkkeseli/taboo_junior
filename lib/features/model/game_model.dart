
import 'package:hive_flutter/hive_flutter.dart';

part 'game_model.g.dart';

@HiveType(typeId: 1)
class GameModel {
  @HiveField(0)
  String? teamName1;
  @HiveField(1)
  String? teamName2;
  @HiveField(2)
  int? pass;
  @HiveField(3)
  int? time;
  @HiveField(4)
  int? point;

  GameModel({
    this.teamName1,
    this.teamName2,
    this.pass,
    this.time,
    this.point,
  });
}
