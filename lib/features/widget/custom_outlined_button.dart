import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final double maxWidth;
  final IconData icon;
  const CustomOutlinedButton({
    super.key,
    required this.title,
    this.onPressed,
    required this.maxWidth,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          fixedSize: Size(maxWidth - 70, maxWidth * .19),
          side: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        label: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.white),
        ),
        icon: Icon(
          icon,
          size: 40,
        ));
  }
}
