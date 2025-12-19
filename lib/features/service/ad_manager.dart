import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // Test Ad Unit IDs - Production için .env dosyasından alınacak
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_BANNER_ANDROID'] ??
          'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_BANNER_IOS'] ??
          'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_INTERSTITIAL_ANDROID'] ??
          'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_INTERSTITIAL_IOS'] ??
          'ca-app-pub-3940256099942544/4411468910'; // Test ID
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
        onAdOpened: (ad) => print('BannerAd opened'),
        onAdClosed: (ad) => print('BannerAd closed'),
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
          print('InterstitialAd loaded successfully');
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
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
      print('InterstitialAd is not loaded yet');
      onAdDismissed();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('InterstitialAd showed full screen');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('InterstitialAd dismissed');
        ad.dispose();
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('InterstitialAd failed to show: $error');
        ad.dispose();
        onAdDismissed();
      },
    );

    ad.show();
  }
}
