import 'package:tabumium/features/utility/const/constant_string.dart';

enum EnumSound {
  click,
  correct,
  tabu,
  pass,
  victory,
  stopTime;

  String get soundPath {
    switch (this) {
      case EnumSound.click:
        return ConstantString.clickSound;
      case EnumSound.correct:
        return ConstantString.trueSound;
      case EnumSound.tabu:
        return ConstantString.tabuSound;
      case EnumSound.pass:
        return ConstantString.passSound;
      case EnumSound.victory:
        return ConstantString.victorySound;
      case EnumSound.stopTime:
        return ConstantString.stopTimeSound;
    }
  }
}
