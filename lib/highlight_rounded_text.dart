import 'dart:ui';
import 'package:flutter/material.dart';
import 'custom_func.dart';

/// [HighlightTextRounded] is a widget which
/// wraps [TextSpan] with specified [Color].
/// Given [double] bold as how thick the color shows
/// and [double] radius for how round the corners are
///
/// Example usage:
///
/// ```dart
/// HighlightText(
///   text: "This is example",
///   textAlign: TextAlign.center,
///   bold: 5,
///   radius: 5,
///   markColor: Colors.amber,
///   style: TextStyle(
///     fontSize: 27,
///     fontWeight: FontWeight.bold,
///     color: Colors.black,
///   ),
/// ),
/// ```

class HighlightTextRounded extends StatelessWidget {
  const HighlightTextRounded({
    Key? key,
    required this.text,
    required this.style,
    this.maxWidth,
    this.radius = 5,
    this.markColor = Colors.white,
    this.textAlign = TextAlign.center,
    this.bold = 5,
    this.isAllCornerRound = true,
  }) : super(key: key);

  /// [text] is the [String] to render
  final String text;

  /// Yeah, you know what [TextStyle] do 😏
  final TextStyle style;

  /// The [maxWidth] parameter, of type [double],
  /// determines the maximum width of the text
  /// and is used to control the way the text is rendered in Flutter
  final double? maxWidth;

  /// The [radius] parameter, of type [double],
  /// represents the rounded corner value that is used
  /// to define all corners
  final double radius;

  /// The [markColor] parameter, of type [Color],
  /// specifies the color used
  /// for the background and rounded border colors
  final Color markColor;

  /// The [textAlign] parameter, of type [TextAlign],
  /// determines the horizontal alignment of the text
  final TextAlign textAlign;

  /// The [bold] parameter, of type [double],
  /// determines how far the border is rendered
  /// from each side of the text
  final double bold;

  /// The [isAllCornerRound], of type [bool]
  /// determines is all corner(90° and 270°)
  /// is rounded by [radius] value or not.
  /// If yes all corners will be rounded.
  /// If not, only 270° corners will be rounded
  final bool isAllCornerRound;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size painterSize = textSize(text, style, maxWidth ?? width);

    return Center(
      child: SizedBox(
        height: painterSize.height + (bold * 2),
        width: painterSize.width + (bold * 2),
        child: Center(
          child: SizedBox(
            height: painterSize.height,
            width: painterSize.width,
            child: CustomPaint(
              painter: HightlightPaint(
                text: text,
                style: style,
                maxWidth: maxWidth ?? width,
                radius: radius,
                colors: markColor,
                textAlign: textAlign,
                bold: bold,
                isAllCornerRound: isAllCornerRound,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HightlightPaint extends CustomPainter {
  final String text;
  final TextStyle style;
  final double maxWidth;
  final double radius;
  final Color colors;
  final TextAlign textAlign;
  final double bold;
  final bool isAllCornerRound;

  HightlightPaint({
    required this.text,
    required this.style,
    required this.maxWidth,
    required this.radius,
    required this.colors,
    required this.textAlign,
    required this.bold,
    required this.isAllCornerRound,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thePaint = Paint()
      ..color = colors
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final textSpan = TextSpan(
      text: text,
      style: style,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: maxWidth,
    );

    List<LineMetrics> lines = textPainter.computeLineMetrics();

    if (isAllCornerRound) {
      Path thePath = Path();
      List<Offset> tempPos = [];
      List<int> order = generateList(lines.length);
      for (var line in lines) {
        final left = line.left;
        final top = line.baseline - line.ascent;
        final right = left + line.width;
        final bottom = line.baseline + line.descent;

        List<Offset> tempList = [
          Offset(left - bold, top - bold),
          Offset(left - bold, bottom + bold),
          Offset(right + bold, bottom + bold),
          Offset(right + bold, top - bold),
        ];
        tempPos.addAll(tempList);
      }
      drawCustomRounded(
        thePath: thePath,
        tempPos: tempPos,
        order: order,
        length: lines.length,
        textAlign: textAlign,
        radius: radius,
      );

      canvas.drawPath(thePath, thePaint);
    } else {
      drawCustomRect(
        canvas: canvas,
        radius: radius,
        thePaint: thePaint,
        lines: lines,
        bold: bold,
      );
    }

    textPainter.paint(
      canvas,
      Offset.zero,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void drawCustomRect({
  required Canvas canvas,
  required double radius,
  required Paint thePaint,
  required List<LineMetrics> lines,
  required double bold,
}) {
  for (var line in lines) {
    final left = line.left;
    final top = line.baseline - line.ascent;
    final right = left + line.width;
    final bottom = line.baseline + line.descent;

    canvas.drawRRect(
      RRect.fromLTRBR(
        left - bold,
        top - bold,
        right + bold,
        bottom + bold,
        Radius.circular(radius),
      ),
      thePaint,
    );
  }
}

void drawCustomRounded({
  required Path thePath,
  required List<Offset> tempPos,
  required List<int> order,
  required int length,
  required TextAlign textAlign,
  required double radius,
}) {
  for (var i = 0; i < order.length; i++) {
    final xPos = tempPos[order[i]].dx;
    final yPos = tempPos[order[i]].dy;
    final theIndex = order[i];

    if (theIndex == 0) {
      thePath.moveTo(xPos, yPos + radius);
    } else {
      /// Custom Left Section

      if (order.indexOf(theIndex) < length * 2) {
        final xNext = tempPos[order[i + 1]].dx;
        final yNext = tempPos[order[i + 1]].dy;

        if (textAlign == TextAlign.left || textAlign == TextAlign.start || textAlign == TextAlign.justify) {
          if (theIndex == (length * 4) - 3) {
            thePath.lineTo(xPos, yPos - radius);
            thePath.quadraticBezierTo(xPos, yPos, xPos + radius, yPos);
            thePath.lineTo(xPos + radius, yPos);
          } else {
            thePath.lineTo(xPos, yPos);
          }
        } else {
          if (xPos > xNext) {
            if ((xPos - xNext).abs() < radius) {
              thePath.lineTo(xPos, yNext);
            } else {
              thePath.lineTo(xPos, yNext - radius);
              thePath.quadraticBezierTo(xPos, yNext, xPos - radius, yNext);
              thePath.lineTo(xPos - radius, yNext);
            }
          } else if (xPos < xNext) {
            if ((xPos - xNext).abs() < radius) {
              thePath.lineTo(xPos, yPos - radius);
              thePath.quadraticBezierTo(xPos, yPos, xPos + (xPos - xNext).abs(), yPos);
              thePath.lineTo(xPos + (xPos - xNext).abs(), yPos);
            } else {
              thePath.lineTo(xPos, yPos - radius);
              thePath.quadraticBezierTo(xPos, yPos, xPos + radius, yPos);
              thePath.lineTo(xPos + radius, yPos);
            }
          } else if (xPos == xNext) {
            final xPrev = tempPos[order[i - 1]].dx;
            final yPrev = tempPos[order[i - 1]].dy;

            if (xPrev > xPos) {
              if ((xPrev - xPos).abs() > radius) {
                thePath.lineTo(xPos + radius, yPos);
              }
              thePath.quadraticBezierTo(xPos, yPos, xPos, yPos + radius);
              thePath.lineTo(xPos, yPos + radius);
            } else {
              if ((xPos - xPrev).abs() < radius) {
                thePath.lineTo(xPos, yPrev);
                thePath.lineTo(xPos, yPrev + radius);
              } else {
                thePath.lineTo(xPos - radius, yPrev);
                thePath.quadraticBezierTo(xPos, yPrev, xPos, yPrev + radius);
                thePath.lineTo(xPos, yPrev + radius);
              }
            }
          }
        }
      } else {
        /// Custom Right Section

        final xPrev = tempPos[order[i - 1]].dx;
        final yPrev = tempPos[order[i - 1]].dy;

        if (textAlign == TextAlign.right || textAlign == TextAlign.end) {
          if (theIndex == 3) {
            thePath.lineTo(xPos, yPos + radius);
            thePath.quadraticBezierTo(xPos, yPos, xPos - radius, yPos);
            thePath.lineTo(xPos - radius, yPos);
            thePath.lineTo(tempPos[order[0]].dx + radius, yPos);
            thePath.quadraticBezierTo(
              tempPos[order[0]].dx,
              tempPos[order[0]].dy,
              tempPos[order[0]].dx,
              tempPos[order[0]].dy + radius,
            );
          } else if (theIndex == length * 4 - 2) {
            thePath.lineTo(xPos - radius, yPos);
            thePath.quadraticBezierTo(xPos, yPos, xPos, yPos - radius);
            thePath.lineTo(xPos, yPos - radius);
          } else {
            thePath.lineTo(xPos, yPos);
          }
        } else {
          if (xPos < xPrev) {
            if ((xPos - xPrev).abs() < radius) {
              thePath.quadraticBezierTo(xPos, yPos, xPos, yPrev - radius);
              thePath.lineTo(xPos, yPos - radius);
            } else {
              thePath.lineTo(xPos + radius, yPrev);
              thePath.quadraticBezierTo(xPos, yPrev, xPos, yPrev - radius);
              thePath.lineTo(xPos, yPos - radius);
            }
          } else if (xPos > xPrev) {
            if ((xPos - xPrev).abs() < radius) {
              thePath.lineTo(xPos - (xPos - xPrev).abs(), yPos);
              thePath.quadraticBezierTo(xPos, yPos, xPos, yPos - (xPos - xPrev).abs());
              thePath.lineTo(xPos, yPos - (xPos - xPrev).abs());
            } else {
              thePath.lineTo(xPos - radius, yPos);
              thePath.quadraticBezierTo(xPos, yPos, xPos, yPos - radius);
              thePath.lineTo(xPos, yPos - radius);
            }
          } else if (xPos == xPrev && theIndex != 3) {
            final xNext = tempPos[order[i] - 5].dx;
            final yNext = tempPos[order[i] - 5].dy;
            if (xPos < xNext) {
              if ((xPos - xNext).abs() < radius) {
                thePath.lineTo(xPos, yNext);
                thePath.quadraticBezierTo(xPos, yNext, xNext, yNext);
                thePath.lineTo(xNext, yNext);
              } else {
                thePath.lineTo(xPos, yNext + radius);
                thePath.quadraticBezierTo(xPos, yNext, xPos + radius, yNext);
                thePath.lineTo(xPos + radius, yNext);
              }
            } else if (xPos > xNext) {
              thePath.lineTo(xPos, yPos + radius);
              thePath.quadraticBezierTo(xPos, yPos, xPos - radius, yPos);
              thePath.lineTo(xPos - radius, yPos);
            }
          } else if (theIndex == 3) {
            thePath.lineTo(xPos, yPos + radius);
            thePath.quadraticBezierTo(xPos, yPos, xPos - radius, yPos);
            thePath.lineTo(xPos - radius, yPos);
            thePath.lineTo(tempPos[order[0]].dx + radius, yPos);
            thePath.quadraticBezierTo(
              tempPos[order[0]].dx,
              tempPos[order[0]].dy,
              tempPos[order[0]].dx,
              tempPos[order[0]].dy + radius,
            );
          }
        }
      }
    }
  }
}
