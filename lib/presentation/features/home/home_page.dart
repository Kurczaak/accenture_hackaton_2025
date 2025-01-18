import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/chat_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onbarding_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_loading_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/symptom/new_symptom_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingPage()),
                  );
                },
                child: const MyText(text: 'Onboarding'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewSymptomPage()),
                  );
                },
                child: const MyText(text: 'New Symptom'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
                child: const MyText(text: 'Chat page'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OnboardingLoadingPage()),
                  );
                },
                child: const MyText(text: 'Onboarding Loading'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
