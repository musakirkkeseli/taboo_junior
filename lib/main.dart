import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_color.dart';

import 'features/utility/cache_manager.dart';
import 'product/home/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.db.init();
  if (CacheManager.db.getGameModel() == null) {
    print("getGameModel null");
    await CacheManager.db.clearGameModel();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: ConstColor.secondColor,
          appBarTheme: AppBarTheme(
              backgroundColor: ConstColor.primaryColor,
              foregroundColor: ConstColor.secondColor,
              centerTitle: true,
              titleTextStyle: TextStyle(fontSize: 20)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ConstColor.primaryColor,
                  foregroundColor: ConstColor.secondColor)),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            filled: true,
            fillColor: ConstColor.primaryColor,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: ConstColor.secondColor),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: ConstColor.secondColor,
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: ConstColor.primaryColor,
            thumbColor: ConstColor.primaryColor,
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}
