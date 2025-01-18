import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingLoadingPage extends StatefulWidget {
  @override
  State<OnboardingLoadingPage> createState() => _OnboardingLoadingPageState();
}

class _OnboardingLoadingPageState extends State<OnboardingLoadingPage> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds and navigate to the second screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingAppointmentsPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.modulate,
              ),
              child: Lottie.asset(
                'assets/lottie/loading.json',
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