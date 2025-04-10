import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_color.dart';

class CustomSliderWidget extends StatefulWidget {
  final String title;
  final double max;
  final double min;
  final ValueNotifier<double> value;
  const CustomSliderWidget(
      {super.key,
      required this.title,
      required this.max,
      required this.min,
      required this.value});

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  @override
  void initState() {
    // TODO: implement initState
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
              Container(
                color: ConstColor.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  widget.title,
                  style: TextStyle(color: ConstColor.secondColor, fontSize: 20),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.value,
                builder: (context, changevalue, child) => Text(
                  changevalue.toInt().toString(),
                  style:
                      TextStyle(color: ConstColor.primaryColor, fontSize: 20),
                ),
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
}
