class WordCellModel {
  String? value;
  bool isCorrect;
  bool isLocked; // joker ile açılan
  bool isFilled;
  final String correctChar;

  WordCellModel({
    this.value,
    this.isCorrect = false,
    this.isLocked = false,
    this.isFilled = false,
    required this.correctChar,
  });

  void reset() {
    value = null;
    isCorrect = false;
    isFilled = false;
    // isLocked değişmez
  }

  void setChar(String char) {
    value = char;
    isFilled = true;
    isCorrect = char.toLowerCase() == correctChar.toLowerCase();
  }

  void lockWithCorrectChar() {
    value = correctChar;
    isFilled = true;
    isCorrect = true;
    isLocked = true;
  }
}
