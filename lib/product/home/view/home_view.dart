import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/cache_manager.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/widget/custom_elevated_button.dart';
import '../../../features/widget/custom_outlined_button.dart';
import '../../select_category/view/select_category_view.dart';
import 'widget/customSettingSwitch.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier<bool> _sound = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _music = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _vibration = ValueNotifier<bool>(true);
  final sm = SoundManager();

  Future<void> _initSound() async {
    await sm.init(
        sfxOpen: _sound.value,
        musicOpen: _music.value,
        vibration: _vibration.value);
    if (_music.value) {
      await sm.playBackground();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSettingsAndInitSound();
  }

  Future<void> _loadSettingsAndInitSound() async {
    await CacheManager.db.init();
    // load saved settings
    _sound.value = CacheManager.db.getSound();
    _music.value = CacheManager.db.getMusic();
    _vibration.value = CacheManager.db.getVibration();
    await _initSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;

        double appIconHeight = 0.0;
        double appIconWidth = 0.0;
        if (maxHeight * .235 * 1.82 >= maxWidth * .92) {
          appIconHeight = maxHeight * .235;
          appIconWidth = maxHeight * .235 * 1.82;
        } else {
          appIconHeight = maxWidth * .92 * .548;
          appIconWidth = maxWidth * .92;
        }
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ConstantString.homeBg), fit: BoxFit.fill)),
          height: maxHeight,
          width: maxWidth,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 27),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        // fetch package info (version) before showing the dialog
                        String appVersion = '';
                        try {
                          final info = await PackageInfo.fromPlatform();
                          appVersion = "v${info.version}";
                        } catch (_) {
                          appVersion = '';
                        }

                        showDialog(
                          context: context,
                          builder: (ctx) => Center(
                            child: IntrinsicHeight(
                              child: Container(
                                width: MediaQuery.sizeOf(context).width - 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            ConstantString.settingsBg),
                                        fit: BoxFit.fill),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Column(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.sizeOf(context).width - 47,
                                      height: 56,
                                      // keep top rounded background
                                      decoration: BoxDecoration(
                                          color: Color(0xff00A4E5),
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15))),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          // centered title stays exactly centered
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                ConstantString.settings,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                width: 56,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  8)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color(0xFF00A4E5),
                                                      Color(0xFF007EAF),
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 34),
                                      child: Column(
                                        spacing: 20,
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: _sound,
                                              builder:
                                                  (context, soundValue, child) {
                                                return CustomSettingSwitch(
                                                    title: ConstantString.sound,
                                                    isOn: soundValue,
                                                    onTap: () async {
                                                      final newVal =
                                                          !soundValue;
                                                      sm.changeSfxOpen(newVal);
                                                      _sound.value = newVal;
                                                      await CacheManager.db
                                                          .setSound(newVal);
                                                    });
                                              }),
                                          ValueListenableBuilder(
                                              valueListenable: _music,
                                              builder:
                                                  (context, musicValue, child) {
                                                return CustomSettingSwitch(
                                                    title: ConstantString.music,
                                                    isOn: musicValue,
                                                    onTap: () async {
                                                      final newVal =
                                                          !musicValue;
                                                      sm.changeMusicOpen(
                                                          newVal);
                                                      _music.value = newVal;
                                                      await CacheManager.db
                                                          .setMusic(newVal);
                                                    });
                                              }),
                                          ValueListenableBuilder(
                                              valueListenable: _vibration,
                                              builder: (context, vibrationValue,
                                                  child) {
                                                return CustomSettingSwitch(
                                                  title:
                                                      ConstantString.vibration,
                                                  isOn: vibrationValue,
                                                  onTap: () async {
                                                    final newVal =
                                                        !vibrationValue;
                                                    _vibration.value = newVal;
                                                    await CacheManager.db
                                                        .setVibration(newVal);
                                                  },
                                                );
                                              }),
                                          // SizedBox(height: 14),
                                          // OutlinedButton.icon(
                                          //   style: OutlinedButton.styleFrom(
                                          //       side: BorderSide(
                                          //           color: Color(0xff7990C7)),
                                          //       foregroundColor:
                                          //           Color(0xff7990C7),
                                          //       shape:
                                          //           RoundedRectangleBorder(
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(15))),
                                          //   onPressed: () {},
                                          //   icon: Icon(Icons.refresh),
                                          //   label: Text(
                                          //       "Satın Alma İşlemini Geri Yükle"),
                                          // )
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    ConstantString
                                                        .privacyPolicy,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color: Color(
                                                                0xff7990C7)),
                                                  )),
                                              Text(
                                                appVersion,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color:
                                                            Color(0xff7990C7)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(ConstantString.settingsIcSvg),
                    ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: SvgPicture.asset(ConstantString.adsIcSvg),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 56,
                ),
                Image.asset(
                  ConstantString.appIc,
                  height: appIconHeight,
                  width: appIconWidth,
                ),
                Spacer(),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => SoloMapView()));
                //   },
                //   child: Container(
                //       height: maxWidth * .243,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       decoration: BoxDecoration(
                //           image: DecorationImage(
                //               image:
                //                   AssetImage(ConstantString.soloGameButtonBg),
                //               fit: BoxFit.fitWidth)),
                //       child: Row(
                //         spacing: 10,
                //         children: [Icon(Icons.abc), Text("Solo Game")],
                //       )),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                CustomElevatedButton(
                  maxWidth: maxWidth,
                  title: ConstantString.teamGame,
                  onTap: () {
                    sm.playVibrationAndClick();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectCategoryView()));
                  },
                  iconPath: ConstantString.teamGameIc,
                ),
                Spacer(),
                CustomOutlinedButton(
                  maxWidth: maxWidth,
                  title: ConstantString.shareUs,
                  icon: Icons.share,
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
