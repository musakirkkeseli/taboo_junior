import 'package:flutter/material.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

enum EnumCustomAppbarType {
  selectCategory,
  gameSettings,
  winnerTeam;

  String get titleValue {
    switch (this) {
      case EnumCustomAppbarType.selectCategory:
        return ConstantString.selectCategory;
      case EnumCustomAppbarType.gameSettings:
        return ConstantString.gameSettings;
      case EnumCustomAppbarType.winnerTeam:
        return ConstantString.winnerTeam;
    }
  }

  String get imageValue {
    switch (this) {
      case EnumCustomAppbarType.selectCategory:
        return ConstantString.appbarDark;
      case EnumCustomAppbarType.gameSettings:
        return ConstantString.appbarDark;
      case EnumCustomAppbarType.winnerTeam:
        return ConstantString.appbarWinner;
    }
  }

  bool get isBackButtonValue {
    switch (this) {
      case EnumCustomAppbarType.selectCategory:
        return true;
      case EnumCustomAppbarType.gameSettings:
        return true;
      case EnumCustomAppbarType.winnerTeam:
        return false;
    }
  }

  TextStyle? titleStyleValue(BuildContext context) {
    switch (this) {
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
      case EnumCustomAppbarType.winnerTeam:
        return Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ConstColor.customTextColor);
    }
  }
}
