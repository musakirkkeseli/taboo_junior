import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'features/utility/cache_manager.dart';
import 'features/utility/const/app_themes.dart';
import 'product/home/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.db.init();
  if (CacheManager.db.getGameModel() == null) {
    print("getGameModel null");
    await CacheManager.db.clearGameModel();
  }
  final audioContext = AudioContextConfig(
    respectSilence: false,
    stayAwake: false,
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  await AudioPlayer.global.setAudioContext(audioContext);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.themeData,
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
