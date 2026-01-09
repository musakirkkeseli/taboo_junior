import 'package:tabumium/features/utility/const/constant_string.dart';

enum EnumSoloGameButton {
  time,
  pass,
  letter,
  hint;

  String get title {
    switch (this) {
      case EnumSoloGameButton.time:
        return ConstantString.time;
      case EnumSoloGameButton.pass:
        return ConstantString.pass;
      case EnumSoloGameButton.letter:
        return ConstantString.letter;
      case EnumSoloGameButton.hint:
        return ConstantString.hint;
    }
  }

  String get buttonImage {
    switch (this) {
      case EnumSoloGameButton.time:
        return ConstantString.soloGameTimeButtonBg;
      case EnumSoloGameButton.pass:
        return ConstantString.soloGamePassButtonBg;
      case EnumSoloGameButton.letter:
        return ConstantString.soloGameLetterButtonBg;
      case EnumSoloGameButton.hint:
        return ConstantString.soloGameHintButtonBg;
    }
  }
}
