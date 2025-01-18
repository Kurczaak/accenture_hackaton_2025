import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/home/home_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onbarding_page.dart';
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

  final List<String> titles = [
    'Your personal fridge assistant',
    'Helping you keep track of your groceries',
    'And reducing food waste',
  ];

  final List<String> subtitles = [
    'FridgePal is your personal fridge assistant that helps you keep track of your groceries and reduce food waste.',
    'Add items to your fridge and FridgePal will help you keep track of them. You can also set reminders to avoid food waste.',
    'FridgePal will help you reduce food waste by suggesting recipes based on the items you have in your fridge.',
  ];

  _OnboardingStepPageState({required this.step});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (step == 1) {
                        return const OnboardingPage();
                      } else {
                        return OnboardingStepPage(step: step - 1);
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const MyText(text: "Back", color: AppTheme.textColorLight),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppTheme.primaryColorLight),
                iconColor: MaterialStateProperty.all(AppTheme.textColorLight),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (step == 3) {
                        return const HomePage();
                      } else {
                        return OnboardingStepPage(step: step + 1);
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const MyText(text: "Next", color: AppTheme.textColorLight),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppTheme.primaryColorLight),
                iconColor: MaterialStateProperty.all(AppTheme.textColorLight),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/onboarding/step_$step.png', // Path to the image
              width: 300, // Optional: Set image width
              height: 300, // Optional: Set image height
              fit: BoxFit.cover, // Optional: Set how the image should fit
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text: titles[step - 1],
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            MyText(text: subtitles[step - 1]),
          ],
        ),
      ),
    );
  }
}
