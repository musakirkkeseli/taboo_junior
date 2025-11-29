import 'package:flutter/material.dart';

import '../utility/const/constant_color.dart';
import '../utility/const/constant_string.dart';

enum ButtonType { primary, secondary }

class CustomElevatedButton2 extends StatelessWidget {
  final ButtonType buttonType;
  final void Function()? onTap;
  const CustomElevatedButton2({
    super.key,
    this.buttonType = ButtonType.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: (MediaQuery.sizeOf(context).width - 144) * .40,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(buttonType == ButtonType.primary
                      ? ConstantString.backHomeBg
                      : ConstantString.continueButtonBg),
                  fit: BoxFit.fitWidth)),
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(0, -10),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  buttonType == ButtonType.primary
                      ? ConstantString.backToHomeIc
                      : ConstantString.playIc,
                  height: 28,
                  width: 28,
                ),
                Text(
                  buttonType == ButtonType.primary
                      ? ConstantString.backToHome
                      : ConstantString.keepContinue,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: buttonType == ButtonType.primary
                            ? ConstColor.blue607AB8
                            : ConstColor.buttonTextColor,
                      ),
                )
              ],
            ),
          )),
    );
  }
}
