import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/sound_manager.dart';
import '../../../../features/widget/custom_elevated_button.dart';
import '../../../select_category/view/select_category_view.dart';
import '../../../solo_map/view/solo_map_view.dart';

class GameButonsWidget extends StatelessWidget {
  final double maxWidth;
  GameButonsWidget({super.key, required this.maxWidth});

  final sm = SoundManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SoloMapView()),
                  );
                }
              },
              child: Container(
                  height: maxWidth * .243,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ConstantString.soloGameButtonBg),
                          fit: BoxFit.fitWidth)),
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, -10),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ConstantString.soloPlayIc),
                        Text(
                          ConstantString.soloGame,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ConstColor.customTextColor,
                                  ),
                        )
                      ],
                    ),
                  )),
            ),
            Positioned(
              right: 15,
              top: 5,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    ConstantString.comingSoon,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        CustomElevatedButton(
          maxWidth: maxWidth,
          title: ConstantString.teamGame,
          onTap: () {
            sm.playVibrationAndClick();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SelectCategoryView()));
          },
          iconPath: ConstantString.teamGameIc,
        ),
      ],
    );
  }
}
