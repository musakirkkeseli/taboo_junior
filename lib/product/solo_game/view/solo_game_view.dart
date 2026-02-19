import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tabumium/core/utility/logger_service.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_sound.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/service/ad_manager.dart';
import '../../../features/widget/banner_ad_widget.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../../features/widget/custom_elevated_button.dart';
import '../../../features/widget/custom_elevated_button2.dart';
import '../../../features/widget/half_ellipse_clipper.dart';
import '../../solo_map/model/solo_game_model.dart';
import '../cubit/solo_game_cubit.dart';
import 'widget/solo_game_body_widget.dart';

class SoloGameView extends StatefulWidget {
  final int level;
  final List<SoloGameWord> words;
  const SoloGameView({super.key, required this.words, required this.level});

  @override
  State<SoloGameView> createState() => _SoloGameViewState();
}

class _SoloGameViewState extends State<SoloGameView> {
  InterstitialAd? _interstitialAd;
  bool _isGameReady = false;

  final MyLog _log = MyLog('SoloGameView');

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  Future<void> _loadInterstitialAd() async {
    _log.d('Starting to load interstitial ad...');
    _interstitialAd = await AdManager().loadInterstitialAd();
    _log.d(
        'Interstitial ad load completed. Ad is ${_interstitialAd != null ? "loaded" : "null"}');

    if (mounted) {
      _showInterstitialAd();
    }
  }

  void _showInterstitialAd() {
    _log.d('Attempting to show interstitial ad...');
    if (_interstitialAd != null) {
      AdManager().showInterstitialAd(
        _interstitialAd,
        onAdDismissed: () {
          _log.d('Interstitial ad dismissed, starting game...');
          if (mounted) {
            setState(() {
              _isGameReady = true;
            });
          }
        },
      );
    } else {
      _log.d('No interstitial ad to show, starting game immediately...');
      if (mounted) {
        setState(() {
          _isGameReady = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGameReady) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ConstantString.gameBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: ConstColor.primaryColor,
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => SoloGameCubit(widget.words)..startSoloGame(),
      child: BlocConsumer<SoloGameCubit, SoloGameState>(
        listener: (context, state) {
          if (state.soloGameStatus == SoloGameStatus.gamefinish) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ConstantString.gameBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      _appbar(state),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SoloGameBodyWidget(
                          cubitContext: context,
                          level: widget.level,
                          wordCount: state.wordCount,
                          wordIndex: state.wordIndex,
                          word: state.word ?? "",
                          jokerClue: state.jokerClue ?? "",
                          clues1: state.clues1,
                          clues2: state.clues2,
                        ),
                      ),
                    ],
                  ),
                  if (state.soloGameStatus == SoloGameStatus.gamePause ||
                      state.soloGameStatus == SoloGameStatus.gameExit)
                    pauseAndExitOverlay(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appbar(SoloGameState state) {
    switch (state.soloGameStatus) {
      case SoloGameStatus.gamefinish:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.winnerTeam,
        );
      case SoloGameStatus.gamePause:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.pauseGame,
        );
      case SoloGameStatus.gameExit:
        return CustomAppbarWidget(
          appbarType: EnumCustomAppbarType.exitGame,
        );
      default:
        double _t = timeLoading(state.remainingSeconds, state.totalSeconds)
            .clamp(0.0, 1.0);

        return LayoutBuilder(builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double rx = w * 2.5 / 3.3;
          final double ry = MediaQuery.paddingOf(context).top +
              MediaQuery.sizeOf(context).width * .200;
          return ClipPath(
            clipper: HalfEllipseClipper(rx: rx, ry: ry),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, _t, _t, 1.0],
                      colors: [
                        _t == 0 ? Colors.black : Colors.green,
                        _t == 0 ? Colors.black : Colors.green,
                        Colors.black,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ConstantString.appbarLight),
                            fit: BoxFit.fill)),
                    width: w,
                    height: ry,
                    padding:
                        EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                    child: Builder(builder: (context) {
                      final int minutes = state.remainingSeconds ~/ 60;
                      final int secs = state.remainingSeconds % 60;
                      final String timeString =
                          '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${ConstantString.remainingTime}\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ConstColor.textColor),
                            ),
                            TextSpan(
                              text: timeString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: ConstColor.textColor),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Visibility(
                  visible: state.remainingSeconds == 0 ? false : true,
                  child: Positioned(
                    left: 20,
                    top: MediaQuery.paddingOf(context).top + 10,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffC600A5),
                        border: Border.all(
                          color: Color(0xFF25C1FF),
                          width: 3,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          SoundManager()
                              .playVibrationAndClick(sound: EnumSound.stopTime);
                          context.read<SoloGameCubit>().stopAndStartTimer();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: MediaQuery.paddingOf(context).top + 10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff0069BF),
                      border: Border.all(
                        color: Color(0xFF25C1FF),
                        width: 3,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    }
  }

  Widget pauseAndExitOverlay(BuildContext context, SoloGameState state) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 80),
            state.soloGameStatus == SoloGameStatus.gamePause
                ? BannerAdWidget()
                : SizedBox(),
            Spacer(),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.sizeOf(context).width;
                final screenHeight = MediaQuery.sizeOf(context).height;

                // İkon oranları
                const horizontalRatio =
                    0.55; // resmin yatay uzunluğu / ekranın yatay uzunluğu
                const verticalRatio =
                    0.256; // resmin dikey uzunluğu / ekranın dikey uzunluğu
                const aspectRatio = 1.0; // resmin yatay / resmin dikey

                // Önce yatay orana göre hesapla
                double iconWidth = screenWidth * horizontalRatio;
                double iconHeight = iconWidth / aspectRatio;

                // Eğer dikey olarak sığmıyorsa, dikey orana göre yeniden hesapla
                if (iconHeight > screenHeight * verticalRatio) {
                  iconHeight = screenHeight * verticalRatio;
                  iconWidth = iconHeight * aspectRatio;
                }

                return Image.asset(
                  state.soloGameStatus == SoloGameStatus.gamePause
                      ? ConstantString.pauseGameIc
                      : ConstantString.exitGameIc,
                  width: iconWidth,
                  height: iconHeight,
                );
              },
            ),
            SizedBox(height: 20),
            Text(
                state.soloGameStatus == SoloGameStatus.gamePause
                    ? ConstantString.gamePaused
                    : ConstantString.exitGameConfirmation,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: ConstColor.white),
                textAlign: TextAlign.center),
            Spacer(),
            state.soloGameStatus == SoloGameStatus.gamePause
                ? CustomElevatedButton(
                    maxWidth: MediaQuery.sizeOf(context).width,
                    title: ConstantString.keepContinue,
                    onTap: () {
                      SoundManager().playVibrationAndClick();
                      context.read<SoloGameCubit>().stopAndStartTimer();
                    },
                    iconPath: ConstantString.playIc,
                  )
                : Column(
                    children: [
                      CustomElevatedButton2(
                        buttonType: ButtonType.secondary,
                        onTap: () {
                          SoundManager().playVibrationAndClick();
                          context.read<SoloGameCubit>().stopAndStartTimer();
                        },
                      ),
                      CustomElevatedButton2(
                        buttonType: ButtonType.primary,
                        onTap: () {
                          context.read<SoloGameCubit>().close();
                          SoundManager().playVibrationAndClick();
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                      ),
                    ],
                  ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
          ],
        ),
      ),
    );
  }

  double timeLoading(int remainingSeconds, int totalSeconds) {
    if (totalSeconds == 0) return 0.0;
    return ((totalSeconds - remainingSeconds) / totalSeconds);
  }
}
