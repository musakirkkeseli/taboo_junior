import 'package:flutter/material.dart';

import '../utility/const/constant_color.dart';
import '../utility/const/constant_string.dart';

class CustomSliderWidget extends StatefulWidget {
  final String title;
  final double max;
  final double min;
  final String valueString;
  final ValueNotifier<double> value;
  const CustomSliderWidget(
      {super.key,
      required this.title,
      required this.max,
      required this.min,
      required this.valueString,
      required this.value});

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.value.value > widget.min && widget.value.value < widget.max) {
    } else {
      widget.value.value = widget.min;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 5, right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: ConstColor.white),
              ),
              ValueListenableBuilder(
                valueListenable: widget.value,
                builder: (context, changevalue, child) => Text(
                    changevalueString(changevalue),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ConstColor.white)),
              )
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.value,
          builder: (context, changevalue, child) => Slider(
            value: changevalue,
            onChanged: (e) {
              widget.value.value = e;
            },
            max: widget.max,
            min: widget.min,
            divisions: widget.max.toInt() - widget.min.toInt(),
          ),
        )
      ],
    );
  }

  String changevalueString(double changevalue) {
    switch (widget.title) {
      case ConstantString.difficulty:
        return getdifficultyString(changevalue.toInt());
      default:
        return "${changevalue.toInt().toString()} ${widget.valueString}";
    }
  }

  String getdifficultyString(int value) {
    switch (value) {
      case 1:
        return ConstantString.easy;
      case 2:
        return ConstantString.medium;
      case 3:
        return ConstantString.hard;
      case 4:
        return ConstantString.expert;
      default:
        return ConstantString.medium;
    }
  }
}
