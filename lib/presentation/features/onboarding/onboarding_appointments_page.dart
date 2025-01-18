import 'package:accenture_hackaton_2025/presentation/common/button.dart';
import 'package:accenture_hackaton_2025/presentation/common/text.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/appointment_cell.dart';
import 'package:accenture_hackaton_2025/presentation/features/appointment/model/appointment.dart';
import 'package:accenture_hackaton_2025/presentation/features/home/home_page.dart';
import 'package:flutter/material.dart';

class OnboardingAppointmentsPage extends StatefulWidget {
  const OnboardingAppointmentsPage({super.key});

  @override
  State<OnboardingAppointmentsPage> createState() =>
      _OnboardingResultsPageState();
}

class _OnboardingResultsPageState extends State<OnboardingAppointmentsPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Schedule'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: MyButton(
          label: "Confinue",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
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
                text: "Appointments have been scheduled for you:",
                size: 18,
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    AppointmentCell(
                      appointment: Appointment(
                          appointmentName: "Blood tests",
                          date: DateTime.now(),
                          office: "Office 20.2",
                          doctor: "Mike Peterson"),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
