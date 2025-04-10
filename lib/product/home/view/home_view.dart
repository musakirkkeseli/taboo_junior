import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';
import 'package:tabu_app/product/game/view/game_view.dart';
import 'package:tabu_app/product/settings/view/settings_view.dart';

import '../../../features/widget/custom_elevated_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Tabu",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(0xffA31D1D),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomElevatedButton(
                title: ConstantString.game,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GameView()));
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                title: ConstantString.settings,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
