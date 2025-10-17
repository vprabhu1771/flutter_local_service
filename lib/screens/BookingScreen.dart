import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/Appointment.dart';
import '../utils/Constants.dart';

class BookingScreen extends StatefulWidget {
  final String title;

  const BookingScreen({super.key, required this.title});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final storage = FlutterSecureStorage();
  List<Appointment> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      final response = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.MY_BOOKING_ROUTE),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List<dynamic>;
        setState(() {
          appointments = data.map((item) => Appointment.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments.');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch appointments.')),
      );
    }
  }

  Widget buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.calendar_today, color: Colors.white),
        ),
        title: Text(
          appointment.name ?? 'No Title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${appointment.appointment_date ?? 'N/A'}'),
            Text('Time: ${appointment.appointment_time ?? 'N/A'}'),
            Text('Status: ${appointment.status ?? 'Pending'}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to appointment details if needed
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? Center(child: Text('No bookings found.', style: TextStyle(fontSize: 16)))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) => buildAppointmentCard(appointments[index]),
      ),
    );
  }
}
