import '../const/constant_string.dart';

enum SliderType { time, point, difficulty, pass }

extension SliderTypeTitleExtension on SliderType {
  String get titleValue {
    switch (this) {
      case SliderType.pass:
        return ConstantString.passCount;
      case SliderType.time:
        return ConstantString.gameTime;
      case SliderType.point:
        return ConstantString.maxPoint;
      case SliderType.difficulty:
        return ConstantString.difficulty;
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
      case SliderType.difficulty:
        return 4;
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
      case SliderType.difficulty:
        return 1;
    }
  }
}

extension SliderTypeValueStringExtension on SliderType {
  String get valueString {
    switch (this) {
      case SliderType.pass:
        return ConstantString.times;
      case SliderType.time:
        return ConstantString.second;
      case SliderType.point:
        return "";
      case SliderType.difficulty:
        return "";
    }
  }
}
