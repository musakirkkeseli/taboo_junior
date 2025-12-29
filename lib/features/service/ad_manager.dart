import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tabumium/core/utility/logger_service.dart';

import '../utility/const/constant_string.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  final MyLog _log = MyLog('AdManager');

  // Test Ad Unit IDs - Production için .env dosyasından alınacak
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return ConstantString.admobBannerAndroid;
    } else if (Platform.isIOS) {
      return ConstantString.admobBannerIos;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return ConstantString.admobInterstitialAndroid;
    } else if (Platform.isIOS) {
      return ConstantString.admobInterstitialIos;
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Banner Ad oluşturma
  BannerAd createBannerAd({
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) => _log.d('BannerAd opened'),
        onAdClosed: (ad) => _log.d('BannerAd closed'),
      ),
    );
  }

  // Interstitial Ad yükleme
  Future<InterstitialAd?> loadInterstitialAd() async {
    final completer = Completer<InterstitialAd?>();

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _log.d('InterstitialAd loaded successfully');
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _log.e('InterstitialAd failed to load: $error');
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  // Interstitial Ad gösterme
  void showInterstitialAd(
    InterstitialAd? ad, {
    required VoidCallback onAdDismissed,
  }) {
    if (ad == null) {
      _log.d('InterstitialAd is not loaded yet');
      onAdDismissed();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _log.d('InterstitialAd showed full screen');
      },
      onAdDismissedFullScreenContent: (ad) {
        _log.d('InterstitialAd dismissed');
        ad.dispose();
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _log.e('InterstitialAd failed to show: $error');
        ad.dispose();
        onAdDismissed();
      },
    );

    ad.show();
  }
}
