import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/appointment_cell.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onboarding_chat_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Appointments'),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingChatPage()),
          );
        },
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
      body: BlocProvider(
          create: (context) => getIt<ChatCubit>()..init(),
          child: Builder(
            builder: (context) {
              return BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.scheduledAppointments.isEmpty)
                          const MyText(
                            text: "No scheduled appointments",
                          ),
                        if (!state.scheduledAppointments.isEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.scheduledAppointments.length,
                            itemBuilder: (context, index) {
                              return AppointmentCell(
                                  appointment:
                                      state.scheduledAppointments[index]);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
