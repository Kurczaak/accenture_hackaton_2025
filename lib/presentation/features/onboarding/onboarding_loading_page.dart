import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class OnboardingLoadingPage extends StatefulWidget {
  const OnboardingLoadingPage({super.key});

  @override
  State<OnboardingLoadingPage> createState() => _OnboardingLoadingPageState();
}

class _OnboardingLoadingPageState extends State<OnboardingLoadingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatCubit>()..init(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Builder(builder: (context) {
            return Builder(builder: (context) {
              return const _Body();
            });
          }),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state.appointments.length > 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OnboardingAppointmentsPage(
                appointments: state.appointments,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ]);
      },
    );
  }
}
