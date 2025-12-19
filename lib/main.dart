import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/utility/http_service.dart';
import 'features/utility/cache_manager.dart';
import 'features/utility/const/app_themes.dart';
import 'features/utility/const/environment.dart';
import 'product/home/view/home_view.dart';
import 'product/select_category/cubit/select_category_cubit.dart';
import 'product/select_category/service/select_category_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  await CacheManager.db.init();
  await HttpService.init();
  await MobileAds.instance.initialize();
  final audioContext = AudioContextConfig(
    respectSilence: false,
    stayAwake: false,
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  await AudioPlayer.global.setAudioContext(audioContext);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SelectCategoryCubit>(
          lazy: false,
          create: (context) =>
              SelectCategoryCubit(SelectCategoryService(HttpService()))
                ..fetchCategories(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
