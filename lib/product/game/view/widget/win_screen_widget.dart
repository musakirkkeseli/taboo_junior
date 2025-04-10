import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/enum/enum_teams.dart';

import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/widget/custom_elevated_button.dart';
import '../../cubit/game_cubit.dart';

class WinScreenWidget extends StatelessWidget {
  final GameState state;
  const WinScreenWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        state.winTeam == null
            ? Text(
                "Beraber ile dostluk kazandı",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffA31D1D),
                    fontWeight: FontWeight.bold),
              )
            : Text(
                "${state.winTeam == Teams.team1 ? state.teamPoint1 : state.teamPoint2} puan ile ${TeamManager(state.winTeam ?? Teams.team1).nameValue} Kazandı",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffA31D1D),
                    fontWeight: FontWeight.bold),
              ),
        SizedBox(
          height: 20,
        ),
        CustomElevatedButton(
          title: ConstantString.backToHome,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
