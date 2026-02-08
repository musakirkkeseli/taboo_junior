part of 'solo_map_cubit.dart';

class SoloMapState {
  final EnumGeneralStateStatus status;
  final List<SoloGame>? soloGameList;
  final SoloGame? soloGame;

  SoloMapState({
    this.status = EnumGeneralStateStatus.loading,
    this.soloGameList,
    this.soloGame,
  });

  SoloMapState copyWith({
    EnumGeneralStateStatus? status,
    List<SoloGame>? soloGameList,
    SoloGame? soloGame,
  }) {
    return SoloMapState(
      status: status ?? this.status,
      soloGameList: soloGameList ?? this.soloGameList,
      soloGame: soloGame ?? this.soloGame,
    );
  }
}
