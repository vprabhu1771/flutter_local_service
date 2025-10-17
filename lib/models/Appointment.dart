class Appointment {

  int id;
  String name;
  String appointment_date;
  String appointment_time;
  String status;


  Appointment({
    required this.id,
    required this.name,
    required this.appointment_date,
    required this.appointment_time,
    required this.status,
  });

  Appointment.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        appointment_date = json['appointment_date'],
        appointment_time = json['appointment_time'],
        status = json['status'];
}
