class Appointment {
  final String appointmentName;
  final DateTime date;
  final String office;
  final String doctor;

  Appointment({
    required this.appointmentName,
    required this.date,
    required this.office,
    required this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentName: json['appointmentName'],
      date: DateTime.parse(json['date']),
      office: json['office'],
      doctor: json['doctor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentName': appointmentName,
      'date': date.toIso8601String(),
      'office': office,
      'doctor': doctor,
    };
  }
}
