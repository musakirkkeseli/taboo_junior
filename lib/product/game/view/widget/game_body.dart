import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_color.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

import '../../../../features/utility/enum/enum_control_button.dart';
import '../../../../features/utility/enum/enum_teams.dart';
import '../../cubit/game_cubit.dart';
import '../../model/tabu_model.dart';

class TabuBody extends StatelessWidget {
  final GameState state;
  final int pass;
  final int remainingPassNum;
  const TabuBody(
      {super.key,
      required this.state,
      required this.pass,
      required this.remainingPassNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Teams.values.map((e) {
            return SizedBox(
                height: MediaQuery.sizeOf(context).height * .1,
                width: (MediaQuery.sizeOf(context).width - 50) / 2,
                child: Row(
                  spacing: 14,
                  textDirection:
                      e == Teams.team1 ? TextDirection.ltr : TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffFFFFFF), Color(0xffD6E2FF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(e == Teams.team1 ? 10 : 0),
                            left: Radius.circular(e == Teams.team2 ? 10 : 0),
                          )),
                      child: Container(
                        width: 63,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: e == state.currentTeam
                                ? ConstColor.otherTextColor
                                : ConstColor.white,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(e == Teams.team1 ? 10 : 0),
                              left: Radius.circular(e == Teams.team2 ? 10 : 0),
                            )),
                        child: Text(
                            e == Teams.team1
                                ? formatPoint(state.teamPoint1)
                                : formatPoint(state.teamPoint2),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: e == Teams.team1
                                          ? ConstColor.gameLeftColor
                                          : ConstColor.tabuWordColor,
                                    )),
                      ),
                    ),
                    // Column(
                    //   spacing: 0,
                    //   crossAxisAlignment: e.index == 0
                    //       ? CrossAxisAlignment.start
                    //       : CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //         e == state.currentTeam
                    //             ? "${ConstantString.gameOrder}\n"
                    //             : "",
                    //         style:
                    //             TextStyle(color: Colors.yellow, fontSize: 10)),
                    //     Text(
                    //       TeamManager(e).nameValue,
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white),
                    //     ),
                    //   ],
                    // )
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        textAlign:
                            e.index == 0 ? TextAlign.start : TextAlign.end,
                        text: TextSpan(
                            text: "${ConstantString.gameOrder}\n",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: e == state.currentTeam
                                      ? ConstColor.otherTextColor
                                      : ConstColor.transparent,
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                text: TeamManager(e).nameValue,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: ConstColor.white,
                                    ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ));
          }).toList(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: widgetColumn(context, state),
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    );
  }

  Widget widgetColumn(BuildContext context, GameState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: taboWidget(context, state),
          ),
          // state.status == Status.timerFinish
          //     ? SizedBox(
          //         height: MediaQuery.sizeOf(context).height * .12,
          //         width: MediaQuery.sizeOf(context).height * .25,
          //         child: Column(
          //           children: [
          //             CustomOutlinedButton(
          //               maxWidth: MediaQuery.sizeOf(context).width,
          //               icon: Icons.arrow_forward,
          //               title: ConstantString.keepGoing,
          //               onPressed: () {
          //                 context.read<GameCubit>().changeTeam();
          //               },
          //             )
          //           ],
          //         ),
          //       )
          //     :
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: Buttons.values.map((e) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: state.status == Status.timerFinish ||
                              state.isPaused ||
                              (e == Buttons.Pass && state.remainingPassNum == 0)
                          ? null
                          : e.onTap(context),
                      child: Container(
                        width: 68,
                        height: 78,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(e.backgroundValue),
                                fit: BoxFit.fill)),
                        child: e.iconValue(
                            context, state.remainingPassNum, state.passNum),
                      ),
                    ),
                    Text(e.titleValue,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ConstColor.white,
                            ))
                  ],
                );
                // ElevatedButton(
                //     onPressed: state.status == Status.timerFinish ||
                //             state.isPaused ||
                //             (e == Buttons.Pass && state.passNum == 0)
                //         ? null
                //         : e.onTap(context),
                //     child: e.iconValue(state.passNum));
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
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(ConstantString.bannedWordBg),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ConstantString.tabuWordBg),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    tabuModel.word ?? "",
                    style: (tabuModel.word ?? "").length > 18
                        ? Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: ConstColor.tabuWordColor)
                        : Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: ConstColor.tabuWordColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: (tabuModel.taboo ?? []).map((taboo) {
                      return Text(
                        taboo,
                        style: (taboo.length > 18)
                            ? Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: ConstColor.white)
                            : Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: ConstColor.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      );
                    }).toList(),
                  ),
                ),
              )
              // ListView.builder(
              //   padding: EdgeInsets.all(15),
              //   shrinkWrap: true,
              //   itemCount: (tabuModel.taboo ?? []).length,
              //   itemBuilder: (context, index) {
              //     String taboo = tabuModel.taboo![index];
              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: 40.0),
              //       child: Center(
              //         child: Text(
              //           taboo,
              //           style: (tabuModel.word ?? "").length > 18
              //               ? Theme.of(context)
              //                   .textTheme
              //                   .bodyLarge
              //                   ?.copyWith(color: ConstColor.white)
              //               : Theme.of(context)
              //                   .textTheme
              //                   .titleMedium
              //                   ?.copyWith(color: ConstColor.white),
              //         ),
              //       ),
              //     );
              //   },
              // )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  String formatPoint(int point) {
    if (point >= 0) {
      return point.toString().padLeft(2, '0');
    } else {
      int newpoint = point * (-1);
      return "-${newpoint.toString().padLeft(2, '0')}";
    }
  }
}
