import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    return ".env";
  }

  static String get backendUrl {
    return dotenv.env["BACKEND_URL"] ?? "";
  }

  static String get token {
    return dotenv.env["TOKEN"] ?? "";
  }

  // AdMob Ad Unit IDs
  static String get admobBannerAndroid {
    return dotenv.env["ADMOB_BANNER_ANDROID"] ?? "";
    // "'ca-app-pub-3940256099942544/6300978111'"; // Test ID
  }

  static String get admobBannerIos {
    return dotenv.env["ADMOB_BANNER_IOS"] ?? "";
    // "ca-app-pub-3940256099942544/2934735716"; // Test ID
  }

  static String get admobInterstitialAndroid {
    return dotenv.env["ADMOB_INTERSTITIAL_ANDROID"] ?? "";
    // "ca-app-pub-3940256099942544/1033173712"; // Test ID
  }

  static String get admobInterstitialIos {
    return dotenv.env["ADMOB_INTERSTITIAL_IOS"] ?? "";
    // "ca-app-pub-3940256099942544/4411468910"; // Test ID
  }
}
