import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/appointment_cell.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/model/appointment.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:accenture_hackaton_2025/presentation/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingAppointmentsPage extends StatefulWidget {
  const OnboardingAppointmentsPage({super.key, required this.appointments});

  final List<Appointment> appointments;

  @override
  State<OnboardingAppointmentsPage> createState() =>
      _OnboardingResultsPageState();
}

class _OnboardingResultsPageState extends State<OnboardingAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatCubit>()..init(),
      child: Builder(builder: (context) {
        return _PageBody(
          appointments: widget.appointments,
        );
      }),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({
    required this.appointments,
  });

  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text: "Appointments have been scheduled for you:",
                size: 18,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      AppointmentCell(
                        appointment: Appointment(
                          appointmentName: appointments[index].appointmentName,
                          date: appointments[index].date,
                          office: appointments[index].office,
                          doctor: appointments[index].doctor,
                        ),
                      ),
                      const SizedBox(height: 16),
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
