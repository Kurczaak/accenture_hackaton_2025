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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Appointment &&
        other.appointmentName == appointmentName &&
        other.office == office &&
        other.doctor == doctor;
  }

  @override
  int get hashCode =>
      appointmentName.hashCode ^ office.hashCode ^ doctor.hashCode;

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
