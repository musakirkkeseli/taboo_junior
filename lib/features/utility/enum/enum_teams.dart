import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

import '../../../product/game/cubit/game_cubit.dart';
import '../../model/game_model.dart';
import '../cache_manager.dart';

enum Teams { team1, team2 }

extension TeamsNameExtension on Teams {
  String get nameTitleValue {
    switch (this) {
      case Teams.team1:
        return ConstantString.teamName1;
      case Teams.team2:
        return ConstantString.teamName2;
    }
  }
}

/// **Takım İşlemlerini Yöneten Sınıf**
class TeamManager {
  final Teams team;

  TeamManager(this.team);

  /// **Takım Değişiklik İşlemi**
  Function()? onChange() {
    return () {
      // Buraya onChange işlemleri eklenebilir
    };
  }

  String get nameValue {
    GameModel? gameModel = CacheManager.db.getGameModel();
    if (gameModel == null) {
      CacheManager.db.clearGameModel();
    }
    switch (team) {
      case Teams.team1:
        return gameModel?.teamName1 ?? ConstantString.team1;
      case Teams.team2:
        return gameModel?.teamName2 ?? ConstantString.team2;
    }
  }

  /// **Takım Puan Ekleme İşlemi**
  void onTap(BuildContext context, int point) {
    switch (team) {
      case Teams.team1:
        context.read<GameCubit>().addTeamPoint1(point);
        break;
      case Teams.team2:
        context.read<GameCubit>().addTeamPoint2(point);
        break;
    }
  }
}
