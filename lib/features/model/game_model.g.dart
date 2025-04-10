// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameModelAdapter extends TypeAdapter<GameModel> {
  @override
  final int typeId = 1;

  @override
  GameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameModel(
      teamName1: fields[0] as String?,
      teamName2: fields[1] as String?,
      pass: fields[2] as int?,
      time: fields[3] as int?,
      point: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, GameModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.teamName1)
      ..writeByte(1)
      ..write(obj.teamName2)
      ..writeByte(2)
      ..write(obj.pass)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.point);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
