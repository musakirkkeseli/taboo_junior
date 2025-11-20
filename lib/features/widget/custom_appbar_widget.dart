import 'package:flutter/material.dart';
import 'package:tabumium/features/utility/const/constant_color.dart';

import '../utility/enum/enum_appbar.dart';

class CustomAppbarWidget extends StatelessWidget {
  final EnumCustomAppbarType appbarType;
  const CustomAppbarWidget({super.key, required this.appbarType});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double w = constraints.maxWidth;
      final double rx = w * 2.5 / 2;
      final double ry = MediaQuery.paddingOf(context).top +
          MediaQuery.sizeOf(context).width * .213 / 1.5;
      return ClipPath(
        clipper: _HalfEllipseClipper(rx: rx, ry: ry),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(appbarType.imageValue),
                      fit: BoxFit.fill)),
              width: w,
              height: ry,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: Text(appbarType.titleValue,
                  textAlign: TextAlign.center,
                  style: appbarType.titleStyleValue(context)),
            ),
            Visibility(
              visible: appbarType.isBackButtonValue,
              child: Positioned(
                left: 20,
                top: MediaQuery.paddingOf(context).top,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConstColor.backbg,
                    border: Border.all(
                      color: ConstColor.buttonBorder,
                      width: 3,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: ConstColor.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class _HalfEllipseClipper extends CustomClipper<Path> {
  final double rx;
  final double ry;

  const _HalfEllipseClipper({required this.rx, required this.ry});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Oval centered at the top edge (y = 0). The child container has height = ry,
    // so only the bottom half of this oval will be visible.
    final Rect ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, 0),
      width: rx * 2,
      height: ry * 2,
    );
    path.addOval(ovalRect);
    return path;
  }

  @override
  bool shouldReclip(covariant _HalfEllipseClipper oldClipper) {
    return oldClipper.rx != rx || oldClipper.ry != ry;
  }
}
