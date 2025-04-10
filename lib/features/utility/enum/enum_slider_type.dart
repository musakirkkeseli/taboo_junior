import '../const/constant_string.dart';

enum SliderType { pass, time, point }

extension SliderTypeTitleExtension on SliderType {
  String get titleValue {
    switch (this) {
      case SliderType.pass:
        return ConstantString.pass;
      case SliderType.time:
        return ConstantString.time;
      case SliderType.point:
        return ConstantString.maxPoint;
    }
  }
}

extension SliderTypeMaxValueExtension on SliderType {
  double get maxValue {
    switch (this) {
      case SliderType.pass:
        return 10;
      case SliderType.time:
        return 120;
      case SliderType.point:
        return 50;
    }
  }
}

extension SliderTypeMinValueExtension on SliderType {
  double get minValue {
    switch (this) {
      case SliderType.pass:
        return 1;
      case SliderType.time:
        return 30;
      case SliderType.point:
        return 5;
    }
  }
}

// extension SliderTypeUseValueExtension on SliderType {
//   double get useValue {
//     GameModel? gameModel = CacheManager.db.getGameModel();
//     if (gameModel == null) {
//       CacheManager.db.clearGameModel();
//     }
//     switch (this) {
//       case SliderType.pass:
//         return (gameModel!.pass ?? 0).toDouble();
//       case SliderType.time:
//         return (gameModel!.time ?? 0).toDouble();
//       case SliderType.point:
//         return (gameModel!.point ?? 0).toDouble();
//     }
//   }
// }
