import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

import '../../../product/game/cubit/game_cubit.dart';
import '../const/constant_color.dart';
import '../sound_manager.dart';
import 'enum_sound.dart';

enum Buttons { Pass, False, True }

extension ButtonsElementIconExtension on Buttons {
  Widget? iconValue(
      BuildContext context, int remainingPassNum, int totalPassNum) {
    switch (this) {
      case Buttons.Pass:
        return Transform.translate(
            offset: Offset(0, -10),
            child: Text(
              "${remainingPassNum.toString().padLeft(2, '0')}/${totalPassNum.toString().padLeft(2, '0')}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ConstColor.customTextColor,
                  ),
            ));
      default:
        return null;
    }
  }
}

extension ButtonsElementBGExtension on Buttons {
  String get backgroundValue {
    switch (this) {
      case Buttons.True:
        return ConstantString.trueButtonBg;
      case Buttons.Pass:
        return ConstantString.passButtonBg;
      case Buttons.False:
        return ConstantString.tabooButtonBg;
    }
  }
}

extension ButtonsElementTitleExtension on Buttons {
  String get titleValue {
    switch (this) {
      case Buttons.True:
        return ConstantString.trueTitle;
      case Buttons.Pass:
        return ConstantString.passTitle;
      case Buttons.False:
        return ConstantString.taboTitle;
    }
  }
}

extension ButtonsElementOnTapExtension on Buttons {
  Function()? onTap(BuildContext context) {
    switch (this) {
      case Buttons.True:
        return () {
          SoundManager().playVibrationAndClick(sound: EnumSound.correct);
          context.read<GameCubit>().selectTrue(context);
        };
      case Buttons.Pass:
        return () {
          SoundManager().playVibrationAndClick(sound: EnumSound.pass);
          context.read<GameCubit>().selectPass();
        };
      case Buttons.False:
        return () {
          SoundManager().playVibrationAndClick(sound: EnumSound.tabu);
          context.read<GameCubit>().selectFalse(context);
        };
    }
  }
}
