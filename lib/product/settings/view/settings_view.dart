import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

import '../../../features/model/game_model.dart';
import '../../../features/utility/cache_manager.dart';
import '../../../features/utility/enum/enum_slider_type.dart';
import '../../../features/utility/enum/enum_teams.dart';
import '../../../features/widget/custom_slider_widget.dart';
import '../../../features/widget/team_name_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  GameModel? gameModel;
  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();
  final ValueNotifier<double> passCount = ValueNotifier<double>(3);
  final ValueNotifier<double> timeCount = ValueNotifier<double>(60);
  final ValueNotifier<double> maxPointCount = ValueNotifier<double>(20);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameModel = CacheManager.db.getGameModel();
    if (gameModel == null) {
      CacheManager.db.clearGameModel();
    }
    nameController1.text = gameModel!.teamName1 ?? "";
    nameController2.text = gameModel!.teamName2 ?? "";
    passCount.value = (gameModel!.pass ?? 3).toDouble();
    timeCount.value = (gameModel!.time ?? 60).toDouble();
    maxPointCount.value = (gameModel!.point ?? 20).toDouble();
  }

  List<SliderType> sliderTypeList = SliderType.values;
  List<Teams> teamsTypeList = Teams.values;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantString.settings),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: teamsTypeList.map((e) {
                      return TeamNameWidget(
                        title: e.nameTitleValue,
                        textEditingController: e == Teams.team1
                            ? nameController1
                            : nameController2,
                        validator: (value) {
                          if ((value ?? "").isEmpty) {
                            return ConstantString.notEmptyTeamName;
                          }
                          return null;
                        },
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  children: sliderTypeList.map((e) {
                    return CustomSliderWidget(
                      title: e.titleValue,
                      max: e.maxValue,
                      min: e.minValue,
                      value: useValue(e),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            if (formkey.currentState!.validate()) {
              formkey.currentState!.save();
              print("save pass ${passCount.value}");
              CacheManager.db.putAll(GameModel(
                  teamName1: nameController1.text,
                  teamName2: nameController2.text,
                  pass: passCount.value.toInt(),
                  time: timeCount.value.toInt(),
                  point: maxPointCount.value.toInt()));
              Navigator.pop(context);
            }
          },
          child: Text(ConstantString.save)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ValueNotifier<double> useValue(SliderType e) {
    switch (e) {
      case SliderType.pass:
        return passCount;
      case SliderType.time:
        return timeCount;
      case SliderType.point:
        return maxPointCount;
    }
  }
}
