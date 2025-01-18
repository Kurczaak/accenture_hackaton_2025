import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/model/appointment.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCell extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCell({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatCubit>()..init(),
      child: Builder(builder: (context) {
        return _PageBody(appointment: appointment);
      }),
    );
  }
}

class _PageBody extends StatelessWidget {
  _PageBody({
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              appointment.appointmentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            MyText(
              text:
                  '${appointment.date.day}/${appointment.date.month}/${appointment.date.year} | ${appointment.date.hour}:${appointment.date.minute}',
            ),
            const SizedBox(height: 8),
            MyText(
              text: 'Office: ${appointment.office}',
            ),
            const SizedBox(height: 8),
            MyText(
              text: 'Doctor: ${appointment.doctor}',
            ),
            const SizedBox(height: 16),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    // Handle change date action
                    if (state.scheduledAppointments.contains(appointment)) {
                      context
                          .read<ChatCubit>()
                          .unscheduleAppointment(appointment);
                    } else {
                      context
                          .read<ChatCubit>()
                          .scheduleAppointment(appointment);
                    }
                  },
                  child: Text(
                    state.scheduledAppointments.contains(appointment)
                        ? 'Unshedule Appointment'
                        : 'Schedule Appointment',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
