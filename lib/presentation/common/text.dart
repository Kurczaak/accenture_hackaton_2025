import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:flutter/material.dart';

class MyText extends StatefulWidget {
  final String text;
  final double size;
  final Color color;

  const MyText({
    super.key,
    required this.text,
    this.size = 16,
    this.color = AppTheme.textColorDark,
  });

  @override
  // ignore: no_logic_in_create_state
  State<MyText> createState() => _MyTextState(
        text: text,
        size: size,
        color: color,
      );
}

class _MyTextState extends State<MyText> {
  final String text;
  final double size;
  final Color color;

  _MyTextState({required this.text, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
      ),
    );
  }
}
