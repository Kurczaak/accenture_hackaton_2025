import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:flutter/material.dart';

class OnboardingStepPage extends StatefulWidget {
  final int step;

  const OnboardingStepPage({super.key, required this.step});

  @override
  State<OnboardingStepPage> createState() =>
      _OnboardingStepPageState(step: step);
}

class _OnboardingStepPageState extends State<OnboardingStepPage> {
  final int step;

  _OnboardingStepPageState({required this.step});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: MyButton(
          label: "Continue",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OnboardingStepPage(step: 1)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/onboarding/onboarding_$step.png'),
          ],
        ),
      ),
    );
  }
}
