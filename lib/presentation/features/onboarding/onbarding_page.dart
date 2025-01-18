import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/home/home_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_step_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<String> points = [
    'Your personal fridge assistant',
    'Helping you keep track of your groceries',
    'And reducing food waste',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: MyButton(
          label: "Get Started",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OnboardingStepPage(step: 1)),
            );
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(24, 50, 24, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                    color: AppTheme.textHintColor,
                    fontSize: 24,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'FridgePal',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  // for each point in points

                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(text: 'Your personal fridge assistant'),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                        text: 'Helping you keep track of your groceries'),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(text: 'And reducing food waste.'),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
