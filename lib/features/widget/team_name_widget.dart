import 'package:flutter/material.dart';

class TeamNameWidget extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  const TeamNameWidget(
      {super.key, required this.title, required this.textEditingController, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: textEditingController,
            validator: validator,
          )
        ],
      ),
    );
  }
}
