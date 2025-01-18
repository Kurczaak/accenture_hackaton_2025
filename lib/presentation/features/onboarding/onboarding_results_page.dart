import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_loading_page.dart';
import 'package:flutter/material.dart';

class OnboardingResultsPage extends StatelessWidget {
  final List<String> items;

  const OnboardingResultsPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health and Symptoms'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: MyButton(
          label: "Continue",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnboardingLoadingPage()),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text:
                    "Here's information about your health and symptoms. Review and edit it if needed.",
                size: 18,
              ),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: MyText(
                          text: items[index],
                          size: 18,
                        ),
                      ),
                      if (index != items.length - 1)
                        const Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
