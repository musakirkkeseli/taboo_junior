import 'package:flutter/material.dart';
import '../../../../features/utility/const/constant_string.dart';
import 'word_cell_model.dart';
import 'word_grid_controller.dart';

class WordGridInputWidget extends StatefulWidget {
  final WordGridController controller;
  final VoidCallback? onCompleted;
  final double cellSize;

  const WordGridInputWidget({
    super.key,
    required this.controller,
    this.onCompleted,
    this.cellSize = 52,
  });

  @override
  State<WordGridInputWidget> createState() => _WordGridInputWidgetState();
}

class _WordGridInputWidgetState extends State<WordGridInputWidget> {
  late final TextEditingController _hiddenController;
  late final FocusNode _focusNode;

  /// Bir önceki text değerini tutarak diff algılarız
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _hiddenController = TextEditingController();
    _focusNode = FocusNode();
    widget.controller.addListener(_rebuild);
    _resetHiddenField();
  }

  /// Gizli TextField'ı sıfırla.
  /// Zero-width space (\u200B) sayesinde backspace her zaman algılanır
  /// (boş TextField'da backspace event gelmez).
  void _resetHiddenField() {
    _hiddenController.text = '\u200B';
    _previousText = _hiddenController.text;
    _hiddenController.selection = TextSelection.collapsed(
      offset: _hiddenController.text.length,
    );
  }

  @override
  void dispose() {
    _hiddenController.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onHiddenTextChanged(String newText) {
    final oldText = _previousText;

    if (newText.length > oldText.length) {
      // Yeni karakter(ler) eklendi
      final addedPart = newText.substring(oldText.length);
      for (final c in addedPart.characters) {
        if (RegExp(r'^[a-zA-ZçÇğĞıİöÖşŞüÜ]$').hasMatch(c)) {
          final completed = widget.controller.enterChar(c);
          if (completed) {
            widget.onCompleted?.call();
          }
        }
      }
    } else if (newText.length < oldText.length) {
      // Backspace basıldı
      widget.controller.deleteChar();
    }

    // Her değişiklikte sıfırla ki sürekli yazmaya devam edebilsin
    _resetHiddenField();
  }

  void _requestFocus() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _requestFocus,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gizli input — mobil klavyeyi tetiklemek için ekran dışına konumlandırılmış
          Positioned(
            left: -1000,
            child: SizedBox(
              width: 10,
              height: 10,
              child: TextField(
                controller: _hiddenController,
                focusNode: _focusNode,
                autofocus: true,
                keyboardType: TextInputType.text,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: _onHiddenTextChanged,
              ),
            ),
          ),
          // Görsel hücreler
          _buildCellRow(context),
        ],
      ),
    );
  }

  Widget _buildCellRow(BuildContext context) {
    final cells = widget.controller.cells;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Hücre boyutunu kelime uzunluğuna göre dinamik ayarla
    final maxCellSize = widget.cellSize;
    final totalSpacing = (cells.length - 1) * 6.0;
    final availableWidth = screenWidth - 40; // padding
    final dynamicCellSize =
        ((availableWidth - totalSpacing) / cells.length).clamp(36.0, maxCellSize);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: List.generate(cells.length, (index) {
        return _buildCell(cells[index], index, dynamicCellSize);
      }),
    );
  }

  Widget _buildCell(WordCellModel cell, int index, double size) {
    Color? overlayColor;
    Color textColor;

    if (cell.isLocked) {
      // Joker ile açılmış hücre
      overlayColor = const Color(0xFFFFD700).withValues(alpha: 0.7);
      textColor = Colors.black87;
    } else if (!cell.isFilled) {
      // Boş hücre - sadece beyaz background
      overlayColor = null;
      textColor = Colors.black87;
    } else if (cell.isCorrect) {
      // Doğru harf
      overlayColor = const Color(0xFF4CAF50).withValues(alpha: 0.8);
      textColor = Colors.white;
    } else {
      // Yanlış harf
      overlayColor = const Color(0xFFF44336).withValues(alpha: 0.8);
      textColor = Colors.white;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 200),
      key: ValueKey('anim_${index}_${cell.value}_${cell.isFilled}'),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: AssetImage(ConstantString.pinputBg),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: overlayColor,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            cell.value?.toUpperCase() ?? '',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
