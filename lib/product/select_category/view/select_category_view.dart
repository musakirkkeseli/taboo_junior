import 'package:flutter/material.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_categories.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../settings/view/settings_view.dart';

class SelectCategoryView extends StatelessWidget {
  const SelectCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ConstantString.soloMapBg), fit: BoxFit.fill)),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbarWidget(
              appbarType: EnumCustomAppbarType.selectCategory,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 35, bottom: 35),
                  itemCount: Categories.values.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    Categories category = Categories.values[index];
                    return InkWell(
                      onTap: () {
                        SoundManager().playVibrationAndClick();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsView(
                                      category: category,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage(ConstantString.categoryCardBg),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 16,
                                left: 16,
                                child: Text(category.titleValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: ConstColor.textColor))),
                            Positioned(
                                bottom: 16.3,
                                right: 4.6,
                                child: Container(
                                  height:
                                      (MediaQuery.sizeOf(context).width - 55) /
                                          2 *
                                          .8 *
                                          .8,
                                  width:
                                      (MediaQuery.sizeOf(context).width - 55) /
                                          2 *
                                          .75,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15)),
                                      image: DecorationImage(
                                          image:
                                              AssetImage(category.imageValue),
                                          alignment: Alignment.bottomRight)),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
