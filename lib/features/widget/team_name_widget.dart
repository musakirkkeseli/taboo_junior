import 'package:flutter/material.dart';
import 'package:tabu_app/features/utility/const/constant_color.dart';

class TeamNameWidget extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  const TeamNameWidget(
      {super.key,
      required this.title,
      required this.textEditingController,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ConstColor.white),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: textEditingController,
            validator: validator,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ConstColor.white),
          )
        ],
      ),
    );
  }
}
