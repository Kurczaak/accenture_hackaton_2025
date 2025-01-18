import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const MyButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<MyButton> createState() => _MyButtonState(
        label: label,
        onPressed: onPressed,
      );
}

class _MyButtonState extends State<MyButton> {
  final String label;
  final VoidCallback onPressed;

  _MyButtonState({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 50.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColorLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.textColorDark.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textColorLight,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
