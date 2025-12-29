import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/widget/banner_ad_widget.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../../features/widget/custom_image.dart';
import '../../settings/view/settings_view.dart';
import '../cubit/select_category_cubit.dart';
import '../mıodel/category_model.dart';

class SelectCategoryView extends StatelessWidget {
  const SelectCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectCategoryCubit, SelectCategoryState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ConstantString.soloMapBg),
                  fit: BoxFit.fill)),
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    CustomAppbarWidget(
                      appbarType: EnumCustomAppbarType.selectCategory,
                    ),
                    categoryListBody(state),
                  ],
                ),
                Positioned(
                    bottom: MediaQuery.paddingOf(context).bottom,
                    width: MediaQuery.sizeOf(context).width,
                    child: BannerAdWidget()),
              ],
            ),
          ),
        );
      },
    );
  }

  categoryListBody(SelectCategoryState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: ConstColor.primaryColor,
            ),
          ),
        );
      case EnumGeneralStateStatus.completed:
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 35, bottom: 70),
              itemCount: state.categoryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                CategoryModel category = state.categoryList[index];
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
                            image: AssetImage(ConstantString.categoryCardBg),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 16,
                            left: 16,
                            child: Text(category.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: ConstColor.textColor))),
                        Positioned(
                            bottom: 16.3,
                            right: 4.6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15)),
                              child: SizedBox(
                                height:
                                    (MediaQuery.sizeOf(context).width - 55) /
                                        2 *
                                        .8 *
                                        .8,
                                width: (MediaQuery.sizeOf(context).width - 55) /
                                    2 *
                                    .75,
                                child: CustomImage.image(
                                  "${ConstantString.backendUrl}/assets/${category.cover}",
                                  width:
                                      (MediaQuery.sizeOf(context).width - 55) /
                                          2 *
                                          .75,
                                  height:
                                      (MediaQuery.sizeOf(context).width - 55) /
                                          2 *
                                          .8 *
                                          .8,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomRight,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      default:
        return Expanded(
          child: Center(
            child: Text(
              state.message ?? ConstantString.unexpectedError,
            ),
          ),
        );
    }
  }
}
