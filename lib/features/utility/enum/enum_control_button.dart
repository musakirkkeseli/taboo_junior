import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/game/cubit/game_cubit.dart';
import '../const/constant_color.dart';

enum Buttons { True, Pass, False }

extension ButtonsElementIconExtension on Buttons {
  Widget iconValue(int pass) {
    switch (this) {
      case Buttons.True:
        return Icon(
          Icons.check,
          color: ConstColor.secondColor,
          size: 20,
        );
      case Buttons.Pass:
        return Row(
          children: [
            Icon(
              Icons.next_plan,
              color: ConstColor.secondColor,
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              pass.toString(),
              style: TextStyle(fontSize: 18),
            )
          ],
        );
      case Buttons.False:
        return Icon(
          Icons.cancel,
          color: ConstColor.secondColor,
          size: 20,
        );
    }
  }
}

extension ButtonsElementOnTapExtension on Buttons {
  Function()? onTap(BuildContext context) {
    switch (this) {
      case Buttons.True:
        return () {
          context.read<GameCubit>().selectTrue(context);
        };
      case Buttons.Pass:
        return () {
          context.read<GameCubit>().selectPass();
        };
      case Buttons.False:
        return () {
          context.read<GameCubit>().selectFalse(context);
        };
    }
  }
}
