import 'package:flutter/material.dart';

class HalfEllipseClipper extends CustomClipper<Path> {
  final double rx;
  final double ry;

  const HalfEllipseClipper({required this.rx, required this.ry});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final Rect ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, 0),
      width: rx * 2,
      height: ry * 2,
    );
    path.addOval(ovalRect);
    return path;
  }

  @override
  bool shouldReclip(covariant HalfEllipseClipper oldClipper) {
    return oldClipper.rx != rx || oldClipper.ry != ry;
  }
}