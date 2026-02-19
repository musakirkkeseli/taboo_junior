import 'dart:math';
import 'package:flutter/foundation.dart';
import 'word_cell_model.dart';

class WordGridController extends ChangeNotifier {
  final String word;
  late List<WordCellModel> cells;

  WordGridController({required this.word}) {
    cells = List.generate(
      word.length,
      (i) => WordCellModel(correctChar: word[i]),
    );
  }

  /// Sonraki aktif (kilitli olmayan ve boş) hücrenin index'ini döndürür
  int? get _nextActiveEmptyIndex {
    for (int i = 0; i < cells.length; i++) {
      if (!cells[i].isLocked && !cells[i].isFilled) {
        return i;
      }
    }
    return null;
  }

  /// Son dolu ve aktif hücrenin index'ini döndürür (backspace için)
  int? get _lastActiveFilledIndex {
    for (int i = cells.length - 1; i >= 0; i--) {
      if (!cells[i].isLocked && cells[i].isFilled) {
        return i;
      }
    }
    return null;
  }

  /// Harf girişi — true dönerse kelime tamamlanmış demektir
  bool enterChar(String char) {
    final index = _nextActiveEmptyIndex;
    if (index == null) return false;

    cells[index].setChar(char);
    notifyListeners();

    if (_isComplete && isAllCorrect) {
      return true;
    }
    return false;
  }

  /// Backspace — son aktif dolu hücreyi temizler
  void deleteChar() {
    final index = _lastActiveFilledIndex;
    if (index == null) return;

    cells[index].reset();
    notifyListeners();
  }

  /// Joker: rastgele bir aktif boş hücreyi açar
  /// true dönerse kelime tamamlanmış demektir
  bool revealRandomChar() {
    final unlockedIndices = <int>[];
    for (int i = 0; i < cells.length; i++) {
      if (!cells[i].isLocked && !cells[i].isFilled) {
        unlockedIndices.add(i);
      }
    }

    // Boş ve kilitli olmayan yoksa, dolu ama kilitli olmayanları da dahil et
    if (unlockedIndices.isEmpty) {
      for (int i = 0; i < cells.length; i++) {
        if (!cells[i].isLocked) {
          unlockedIndices.add(i);
        }
      }
    }

    if (unlockedIndices.isEmpty) return false;

    final randomIndex =
        unlockedIndices[Random().nextInt(unlockedIndices.length)];
    cells[randomIndex].lockWithCorrectChar();
    notifyListeners();

    return _isComplete && isAllCorrect;
  }

  /// Tüm hücreler dolu mu?
  bool get _isComplete => cells.every((c) => c.isFilled);

  /// Tüm hücreler doğru mu?
  bool get isAllCorrect => cells.every((c) => c.isCorrect);

  /// Girilen kelimeyi string olarak döndürür
  String get currentWord => cells.map((c) => c.value ?? '').join();

  /// Aktif hücreleri sıfırla (kilitli olanlar kalır)
  void resetAll() {
    for (final cell in cells) {
      if (!cell.isLocked) {
        cell.reset();
      }
    }
    notifyListeners();
  }
}
