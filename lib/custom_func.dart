import 'package:flutter/material.dart';

List<int> generateList(int input) {
  List<int> result = [];
  for (int i = 0; i < input * 4; i++) {
    if (result.length < input * 2) {
      if (i % 4 == 0 || i % 4 == 1) {
        result.add(i);
      }
    } else {}
  }

  for (int i = (input * 4) - 2; i >= 2; i -= 4) {
    result.add(i);
    result.add(i + 1);
  }

  return result;
}

Size textSize(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: null,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);
  return textPainter.size;
}
