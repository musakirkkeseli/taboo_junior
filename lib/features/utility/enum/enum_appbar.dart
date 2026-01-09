import 'package:flutter/material.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

enum EnumCustomAppbarType {
  soloGameMap,
  selectCategory,
  gameSettings,
  pauseGame,
  exitGame,
  winnerTeam;

  String get titleValue {
    switch (this) {
      case EnumCustomAppbarType.soloGameMap:
        return ConstantString.soloGameMap;
      case EnumCustomAppbarType.selectCategory:
        return ConstantString.selectCategory;
      case EnumCustomAppbarType.gameSettings:
        return ConstantString.gameSettings;
      case EnumCustomAppbarType.pauseGame:
        return ConstantString.pauseGame;
      case EnumCustomAppbarType.exitGame:
        return ConstantString.exitGame;
      case EnumCustomAppbarType.winnerTeam:
        return ConstantString.winnerTeam;
    }
  }

  String get imageValue {
    switch (this) {
      case EnumCustomAppbarType.soloGameMap:
        return ConstantString.appbarDark;
      case EnumCustomAppbarType.selectCategory:
        return ConstantString.appbarDark;
      case EnumCustomAppbarType.gameSettings:
        return ConstantString.appbarDark;
      case EnumCustomAppbarType.pauseGame:
        return ConstantString.appbarPause;
      case EnumCustomAppbarType.exitGame:
        return ConstantString.appbarLight;
      case EnumCustomAppbarType.winnerTeam:
        return ConstantString.appbarWinner;
    }
  }

  bool get isBackButtonValue {
    switch (this) {
      case EnumCustomAppbarType.soloGameMap:
        return true;
      case EnumCustomAppbarType.selectCategory:
        return true;
      case EnumCustomAppbarType.gameSettings:
        return true;
      case EnumCustomAppbarType.pauseGame:
      case EnumCustomAppbarType.exitGame:
      case EnumCustomAppbarType.winnerTeam:
        return false;
    }
  }

  TextStyle? titleStyleValue(BuildContext context) {
    switch (this) {
      case EnumCustomAppbarType.soloGameMap:
        return Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ConstColor.white);
      case EnumCustomAppbarType.selectCategory:
        return Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: ConstColor.white);
      case EnumCustomAppbarType.gameSettings:
        return Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: ConstColor.white);
      case EnumCustomAppbarType.pauseGame:
        return Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: ConstColor.white);
      case EnumCustomAppbarType.exitGame:
        return Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: ConstColor.lightBlue);
      case EnumCustomAppbarType.winnerTeam:
        return Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ConstColor.customTextColor);
    }
  }
}
