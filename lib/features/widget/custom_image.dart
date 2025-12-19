import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utility/const/constant_color.dart';

class CustomImage {
  static Widget image(
    String imageUrl, {
    EdgeInsetsGeometry errorWidgetPadding = const EdgeInsets.all(0),
    double size = 80.0,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    double? width,
    double? height,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white70,
            color: Colors.blue[900],
            strokeWidth: 4.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return Icon(Icons.error, color: ConstColor.primaryColor);
      },
    );
  }
}
