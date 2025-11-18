import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_string.dart';

class CustomSettingSwitch extends StatelessWidget {
  final String title;
  final bool isOn;
  final Function()? onTap;
  const CustomSettingSwitch(
      {super.key, required this.title, required this.isOn, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Color(0xff7990C7)),
        ),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 80,
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isOn ? Color(0xFFA8D868) : Color(0xFF9EBBFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color(0xFF7990C7)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // label in center
                Positioned(
                  left: isOn ? 3 : null,
                  right: isOn ? null : 3,
                  child: Text(
                    isOn ? ConstantString.open : ConstantString.closed,
                    style: TextStyle(
                        color: isOn ? Color(0xFF6C9831) : Color(0xFF5E7DC5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // knob
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment:
                      isOn ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
