import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_solo_game_button.dart';
import '../../../../features/widget/banner_ad_widget.dart';
import '../../../../features/widget/custom_elevated_button.dart';
import '../../cubit/solo_game_cubit.dart';
import 'word_grid_controller.dart';
import 'word_grid_input_widget.dart';

class SoloGameBodyWidget extends StatefulWidget {
  final BuildContext cubitContext;
  final int level;
  final int wordCount;
  final int wordIndex;
  final String word;
  final String jokerClue;
  final List<String> clues1;
  final List<String> clues2;
  const SoloGameBodyWidget(
      {super.key,
      required this.cubitContext,
      required this.level,
      required this.wordCount,
      required this.wordIndex,
      required this.word,
      required this.jokerClue,
      required this.clues1,
      required this.clues2});

  @override
  State<SoloGameBodyWidget> createState() => _SoloGameBodyWidgetState();
}

class _SoloGameBodyWidgetState extends State<SoloGameBodyWidget> {
  late WordGridController _gridController;

  // Maksimum joker hakları
  static const int _maxTimeJoker = 1;
  static const int _maxPassJoker = 1;
  static const int _maxLetterJoker = 5;
  static const int _maxHintJoker = 1;

  @override
  void initState() {
    super.initState();
    _gridController = WordGridController(word: widget.word);
  }

  @override
  void didUpdateWidget(covariant SoloGameBodyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word != widget.word) {
      _gridController.dispose();
      _gridController = WordGridController(word: widget.word);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoloGameCubit, SoloGameState>(
      bloc: widget.cubitContext.read<SoloGameCubit>(),
      builder: (context, soloGameState) {
        return SingleChildScrollView(
          child: Column(
            spacing: 32,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 27.0),
                child: Text(
                  "${ConstantString.level} ${widget.level} (${widget.wordIndex} / ${widget.wordCount})",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: ConstColor.white),
                ),
              ),
              Center(
                child: WordGridInputWidget(
                  key: ValueKey(widget.word),
                  controller: _gridController,
                  cellSize: 52,
                  onCompleted: () {
                    MyLog.info("Correct word: ${widget.word}");
                    Navigator.of(context)
                        .push(RawDialogRoute(
                            pageBuilder: (_, animation, secondaryAnimation) =>
                                knowWord(widget.word)))
                        .then((_) {
                      widget.cubitContext
                          .read<SoloGameCubit>()
                          .startTimeForNextWord();
                    });
                    widget.cubitContext.read<SoloGameCubit>().nextWord();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: EnumSoloGameButton.values.map((e) {
                  final isEnabled = _isJokerEnabled(e, soloGameState);
                  return GestureDetector(
                    onTap: isEnabled
                        ? () => _handleButtonTap(widget.cubitContext, e)
                        : null,
                    child: Opacity(
                      opacity: isEnabled ? 1.0 : 0.4,
                      child: Column(
                        children: [
                          Image.asset(e.buttonImage),
                          Text(
                            e.title,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: ConstColor.white),
                          ),
                          if (!isEnabled)
                            Text(
                              _getJokerUsageText(e, soloGameState),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.red.shade300, fontSize: 10),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Visibility(
                  visible: soloGameState.isJokerUsed,
                  child: Text(
                    "${ConstantString.jokerHint} ${widget.jokerClue.toUpperCase()}",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: ConstColor.white),
                  )),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.sizeOf(context).width - 40,
                height: (MediaQuery.sizeOf(context).width - 40) * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ConstantString.soloGameWordListBg),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 19,
                      children: widget.clues1
                          .expand((e) => [
                                Text(
                                  e.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: ConstColor.white),
                                ),
                                Text(
                                  "|",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: ConstColor.white),
                                ),
                              ])
                          .toList()
                        ..removeLast(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 19,
                      children: widget.clues2
                          .expand((e) => [
                                Text(
                                  e.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: ConstColor.white),
                                ),
                                Text(
                                  "|",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: ConstColor.white),
                                ),
                              ])
                          .toList()
                        ..removeLast(),
                    )
                  ],
                ),
              ),
              BannerAdWidget()
            ],
          ),
        );
      },
    );
  }

  knowWord(String word) {
    return AlertDialog(
      backgroundColor: ConstColor.white,
      title: Text(
        ConstantString.congratulations,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ConstColor.buttonTextColor),
      ),
      content: Text(
        word,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: ConstColor.textColor),
      ),
      actions: [
        CustomElevatedButton(
          title: ConstantString.keepContinue,
          onTap: () {
            Navigator.pop(context);
          },
          iconPath: ConstantString.playIc,
          maxWidth: 250,
        )
      ],
    );
  }

  bool _isJokerEnabled(EnumSoloGameButton button, SoloGameState state) {
    switch (button) {
      case EnumSoloGameButton.time:
        return state.timeJokerCount < _maxTimeJoker;
      case EnumSoloGameButton.pass:
        return state.passJokerCount < _maxPassJoker;
      case EnumSoloGameButton.letter:
        return state.letterJokerCount < _maxLetterJoker;
      case EnumSoloGameButton.hint:
        return state.hintJokerCount < _maxHintJoker;
    }
  }

  String _getJokerUsageText(EnumSoloGameButton button, SoloGameState state) {
    switch (button) {
      case EnumSoloGameButton.time:
        return '${state.timeJokerCount}/$_maxTimeJoker';
      case EnumSoloGameButton.pass:
        return '${state.passJokerCount}/$_maxPassJoker';
      case EnumSoloGameButton.letter:
        return '${state.letterJokerCount}/$_maxLetterJoker';
      case EnumSoloGameButton.hint:
        return '${state.hintJokerCount}/$_maxHintJoker';
    }
  }

  void _handleButtonTap(BuildContext cubitContext, EnumSoloGameButton button) {
    MyLog.debug("Button tapped: ${button.title}");

    final soloGameCubit = cubitContext.read<SoloGameCubit>();

    // Joker hakkı kontrolü
    if (!_isJokerEnabled(button, soloGameCubit.state)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${button.title} hakkınız kalmadı!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    switch (button) {
      case EnumSoloGameButton.time:
        soloGameCubit.useTimeJoker();
        break;
      case EnumSoloGameButton.pass:
        _gridController.resetAll();
        Navigator.of(context)
            .push(RawDialogRoute(
                pageBuilder: (_, animation, secondaryAnimation) =>
                    knowWord(widget.word)))
            .then((_) {
          widget.cubitContext.read<SoloGameCubit>().startTimeForNextWord();
        });
        soloGameCubit.usePassJoker();
        break;
      case EnumSoloGameButton.letter:
        soloGameCubit.useLetterJoker();
        _revealLetter();
        break;
      case EnumSoloGameButton.hint:
        _showHint(context);
        break;
    }
  }

  void _revealLetter() {
    final completed = _gridController.revealRandomChar();
    if (completed) {
      MyLog.info("Word completed via joker: ${widget.word}");
      Navigator.of(context)
          .push(RawDialogRoute(
              pageBuilder: (_, animation, secondaryAnimation) =>
                  knowWord(widget.word)))
          .then((_) {
        widget.cubitContext.read<SoloGameCubit>().startTimeForNextWord();
      });
      widget.cubitContext.read<SoloGameCubit>().nextWord();
    }
  }

  void _showHint(BuildContext context) {
    widget.cubitContext.read<SoloGameCubit>().useHintJoker();
  }
}
