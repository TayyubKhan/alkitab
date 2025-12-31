import 'package:flutter/material.dart';

class TajweedTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const TajweedTextWidget(
      {super.key, required this.text, required this.fontSize});

  static const Map<String, Color> _tajweedColors = {
    'ghunnah': Color(0xFF17B890),
    'idgham_w_ghunnah': Color(0xFF17B890),
    'ikhfa': Color(0xFF17B890),
    'idgham_wo_ghunnah': Color(0xFFA9A9A9),
    'qalqalah': Color(0xFF3BA0E8),
    'madda_normal': Color(0xFF8E44AD),
    'madda_permissible': Color(0xFFE67E22),
    'madda_necessary': Color(0xFFD32F2F),
    'ham_wasl': Color(0xFFB0B0B0),
    'slient': Color(0xFFB0B0B0),
  };

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(
        r'<tajweed\s+class=["' ']?([a-zA-Z0-9_]+)["' ']?>(.*?)</tajweed>',
        dotAll: true);
    final input = text;
    int lastIndex = 0;
    final defaultColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    for (final match in regex.allMatches(input)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
            text: input.substring(lastIndex, match.start),
            style: TextStyle(color: defaultColor)));
      }
      final String className = match.group(1) ?? "";
      final String content = match.group(2) ?? "";
      Color color = _tajweedColors[className] ?? defaultColor;

      if (className.startsWith('madd')) {
        color = const Color(0xFF8E44AD);
      } else if (className.startsWith('idgham')) color = const Color(0xFF17B890);

      spans.add(TextSpan(text: content, style: TextStyle(color: color)));
      lastIndex = match.end;
    }
    if (lastIndex < input.length) {
      spans.add(TextSpan(
          text: input.substring(lastIndex),
          style: TextStyle(color: defaultColor)));
    }

    return RichText(
        text: TextSpan(
            style:
                TextStyle(fontSize: fontSize, height: 2.2, color: defaultColor),
            children: spans),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl);
  }
}
