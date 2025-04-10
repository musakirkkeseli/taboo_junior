import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

import '../../../../features/utility/enum/enum_control_button.dart';
import '../../../../features/utility/enum/enum_teams.dart';
import '../../../../features/widget/custom_elevated_button.dart';
import '../../cubit/game_cubit.dart';
import '../../model/tabu_model.dart';

class TabuBody extends StatelessWidget {
  final GameState state;
  final int pass;
  const TabuBody({super.key, required this.state, required this.pass});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: Teams.values.map((e) {
                return Row(
                  children: [
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * .1,
                        width: e == state.currentTeam
                            ? (MediaQuery.sizeOf(context).width - 50) / 4 * 3
                            : (MediaQuery.sizeOf(context).width - 50) / 4 * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              TeamManager(e).nameValue,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                                e == Teams.team1
                                    ? state.teamPoint1.toString()
                                    : state.teamPoint2.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        )),
                    e == Teams.team1
                        ? Container(
                            width: 2, // Çizginin genişliği
                            height: MediaQuery.sizeOf(context).height *
                                .1, // Çizginin uzunluğu
                            color: Colors.red, // Çizginin rengi
                          )
                        : SizedBox()
                  ],
                );
              }).toList(),
            ),
          ),
          Spacer(),
          Text(
            formatTime(state.remainingSeconds),
            style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xffA31D1D)),
          ),
          const SizedBox(height: 20),
          taboWidget(context, state),
          Spacer(),
          state.remainingSeconds == 0
              ? SizedBox()
              : ElevatedButton.icon(
                  onPressed: () {
                    context.read<GameCubit>().stopAndStartTimer();
                  },
                  icon: state.isPaused
                      ? Icon(
                          Icons.play_arrow,
                          color: Color(0xffE5D0AC),
                          size: 30,
                        )
                      : Icon(
                          Icons.pause,
                          color: Color(0xffE5D0AC),
                          size: 20,
                        ),
                  label: state.isPaused
                      ? Text(
                          "Süreyi Başlat",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          "Süreyi Duraklat",
                          style: TextStyle(fontSize: 20),
                        ),
                ),
          Spacer(),
          state.status == Status.timerFinish
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * .1,
                  width: MediaQuery.sizeOf(context).height * .25,
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        title: ConstantString.keepGoing,
                        onPressed: () {
                          context.read<GameCubit>().changeTeam();
                        },
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.sizeOf(context).height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Buttons.values.map((e) {
                      return ElevatedButton(
                          onPressed: state.status == Status.timerFinish ||
                                  state.isPaused ||
                                  (e == Buttons.Pass && state.passNum == 0)
                              ? null
                              : e.onTap(context),
                          child: e.iconValue(state.passNum));
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget taboWidget(BuildContext context, GameState state) {
    if (state.tabuModel is TabuModel) {
      TabuModel tabuModel = state.tabuModel!;
      return ImageFiltered(
        imageFilter: state.isPaused
            ? ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0)
            : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 113, 75, 72),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Color(0xffA31D1D),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabuModel.word ?? "",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              Divider(
                height: 0,
                indent: 0,
                endIndent: 1,
              ),
              ListView.builder(
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                itemCount: (tabuModel.taboo ?? []).length,
                itemBuilder: (context, index) {
                  String taboo = tabuModel.taboo![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: Text(
                        taboo,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }
}
