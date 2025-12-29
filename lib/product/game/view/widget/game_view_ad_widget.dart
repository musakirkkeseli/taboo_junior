import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../features/model/game_model.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/sound_manager.dart';
import '../../../../features/service/ad_manager.dart';
import 'bloc_consumer_widget.dart';

class GameViewAdWidget extends StatefulWidget {
  final GameModel gameModel;
  final String categoryId;
  const GameViewAdWidget(
      {super.key, required this.gameModel, required this.categoryId});

  @override
  State<GameViewAdWidget> createState() => _GameViewAdWidgetState();
}

class _GameViewAdWidgetState extends State<GameViewAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isGameReady = false;

  final MyLog _log = MyLog('GameViewAdWidget');

  @override
  void initState() {
    super.initState();
    SoundManager().stopBackground();
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
    SoundManager().playBackground();
  }

  @override
  Widget build(BuildContext context) {
    return !_isGameReady
        ? Scaffold(
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
          )
        : BlocConsumerWidget(
            gameModel: widget.gameModel,
            categoryId: widget.categoryId,
          );
  }
}
