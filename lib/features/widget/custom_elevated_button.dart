import 'package:flutter/material.dart';

import '../utility/const/constant_color.dart';
import '../utility/const/constant_string.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final double maxWidth;
  final String iconPath;
  const CustomElevatedButton({
    super.key,
    required this.title,
    this.onTap,
    required this.maxWidth,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: maxWidth * .243,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ConstantString.teamGameButtonBg),
                  fit: BoxFit.fitWidth)),
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(0, -10),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ConstColor.buttonTextColor,
                      ),
                )
              ],
            ),
          )),
    );
  }
}
