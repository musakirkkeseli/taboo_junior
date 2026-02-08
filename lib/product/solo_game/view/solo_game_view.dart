import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tabumium/core/utility/logger_service.dart';
import 'package:tabumium/custom_packages/custom_pinput/pinput.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_appbar.dart';
import '../../../features/utility/enum/enum_solo_game_button.dart';
import '../../../features/utility/enum/enum_sound.dart';
import '../../../features/utility/sound_manager.dart';
import '../../../features/service/ad_manager.dart';
import '../../../features/widget/banner_ad_widget.dart';
import '../../../features/widget/custom_appbar_widget.dart';
import '../../../features/widget/half_ellipse_clipper.dart';
import '../cubit/solo_game_cubit.dart';

class SoloGameView extends StatefulWidget {
  final int level;
  final String word;
  final List<String> clues;
  const SoloGameView(
      {super.key,
      required this.word,
      required this.level,
      required this.clues});

  @override
  State<SoloGameView> createState() => _SoloGameViewState();
}

class _SoloGameViewState extends State<SoloGameView> {
  List<String> clues1 = [];
  List<String> clues2 = [];
  InterstitialAd? _interstitialAd;
  bool _isGameReady = false;

  final MyLog _log = MyLog('SoloGameView');

  @override
  void initState() {
    super.initState();
    clues1 = widget.clues.sublist(0, 3);
    clues2 = widget.clues.sublist(3);
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
      create: (context) => SoloGameCubit(widget.word)..startSoloGame(),
      child: BlocConsumer<SoloGameCubit, SoloGameState>(
        listener: (context, state) {},
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
              child: Column(
                children: [
                  _appbar(state),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: body(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _appbar(SoloGameState state) {
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
        double _t = timeLoading(state.remainingSeconds).clamp(0.0, 1.0);

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
                        // if (state.status == EnumGeneralStateStatus.failure) {
                        //   context.read<SoloGameCubit>().stopAndStartTimer();
                        //   context.read<SoloGameCubit>().close();
                        //   Navigator.of(context).pop();
                        // } else {
                        //   SoundManager()
                        //       .playVibrationAndClick(sound: EnumSound.stopTime);
                        //   context.read<SoloGameCubit>().stopAndStartTimer();
                        //   context.read<SoloGameCubit>().isExit();
                        // }
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

  body() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ConstantString.pinputBg),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
    // final focusedPinTheme = defaultPinTheme.copyDecorationWith();
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        image: const DecorationImage(
          image: AssetImage(ConstantString.pinputBg),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.black),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        image: const DecorationImage(
          image: AssetImage(ConstantString.pinputBg),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.red),
      ),
    );
    return SingleChildScrollView(
      child: Column(
        spacing: 32,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 27.0),
            child: Text(
              "LEVEL ${widget.level}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: ConstColor.white),
            ),
          ),
          Center(
            child: Pinput(
              length: widget.word.length,
              autofocus: false,
              defaultPinTheme: defaultPinTheme,
              // focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              errorPinTheme: errorPinTheme,
              keyboardType: TextInputType.text,
              // Character-based validation
              characterValidator: (index, char) {
                // Check if the character at this index matches the word
                if (index < widget.word.length) {
                  return char.toLowerCase() == widget.word[index].toLowerCase();
                }
                return true;
              },
              validator: (s) {
                return "";
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              pinAnimationType: PinAnimationType.rotation,
              showCursor: true,
              onCompleted: (pin) {
                MyLog.debug("Completed: $pin --- ${widget.word}");
                if (pin.toLowerCase() == widget.word.toLowerCase()) {
                  MyLog.info("Correct word!");
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: EnumSoloGameButton.values.map((e) {
              return Column(
                children: [
                  Image.asset(e.buttonImage),
                  Text(
                    e.title,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: ConstColor.white),
                  ),
                ],
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.sizeOf(context).width - 40,
            height: (MediaQuery.sizeOf(context).width - 40) * .3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ConstantString.soloGameWordListBg),
                fit: BoxFit.fitWidth,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 19,
                  children: clues1
                      .expand((e) => [
                            Text(
                              e.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: ConstColor.white),
                            ),
                            Text(
                              "|",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: ConstColor.white),
                            ),
                          ])
                      .toList()
                    ..removeLast(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 19,
                  children: clues2
                      .expand((e) => [
                            Text(
                              e.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: ConstColor.white),
                            ),
                            Text(
                              "|",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: ConstColor.white),
                            ),
                          ])
                      .toList()
                    ..removeLast(),
                )
              ],
            ),
          ),
          BannerAdWidget()
        ],
      ),
    );
  }

  double timeLoading(int seconds) {
    return ((60 - seconds) / 60);
  }
}
