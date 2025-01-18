import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.,
              ),
              child: Lottie.asset(
                'assets/lottie/onboarding.json',
                fit: BoxFit.fitWidth,
              ),
            ),
            const Spacer(),
            const MyText(
              text: 'Just a moment, gathering all the necessary data for you.',
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
