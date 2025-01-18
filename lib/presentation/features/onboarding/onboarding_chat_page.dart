import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_results_page.dart';
import 'package:accenture_hackaton_2025/presentation/features/symptom/new_symptom_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingChatPage extends StatelessWidget {
  const OnboardingChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => getIt<ChatCubit>()..init(),
      child: _PageBody(),
    );
  }
}

class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) async {
        // Check if symptoms list is not empty
        if (state.symptoms.length > 2 && state.lastMessage == null) {
          // Print to verify it's triggering
          print("XXX Hello");

          // Perform navigation when symptoms change
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OnboardingResultsPage(
                items: state.symptoms,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) => const NewSymptomPage(
          isOnboarding: true,
        ),
      ),
    );
  }
}
