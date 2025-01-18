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
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) => const NewSymptomPage(
        isOnboarding: true,
      ),
    );
  }
}
