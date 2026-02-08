import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_solo_game_status.dart';
import '../../model/solo_game_model.dart';

class CustomLevelButton extends StatelessWidget {
  final SoloGame currentLevel;
  final SoloGame level;
  const CustomLevelButton(
      {super.key, required this.level, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      width: 106,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgImage(getSoloGameButtonStatus())),
              fit: BoxFit.fill)),
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(0, -10),
        child: Text(
          level.id.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: textColor(getSoloGameButtonStatus()),
              ),
        ),
      ),
    );
  }

  SoloGameButtonStatus getSoloGameButtonStatus() {
    return SoloGameButtonStatus.status(level.id ?? 0, currentLevel.id ?? 0);
  }

  textColor(SoloGameButtonStatus? status) {
    switch (status) {
      case SoloGameButtonStatus.complated:
        return ConstColor.white;
      case SoloGameButtonStatus.playable:
        return ConstColor.customTextColor;
      case SoloGameButtonStatus.unplayable:
        return ConstColor.textColor;
      default:
        return ConstColor.textColor;
    }
  }

  bgImage(SoloGameButtonStatus? status) {
    switch (status) {
      case SoloGameButtonStatus.complated:
        return ConstantString.complatedLevelBg;
      case SoloGameButtonStatus.playable:
        return ConstantString.playableLevelBg;
      case SoloGameButtonStatus.unplayable:
        return ConstantString.unplayableLevelBg;
      default:
        return ConstantString.unplayableLevelBg;
    }
  }
}
