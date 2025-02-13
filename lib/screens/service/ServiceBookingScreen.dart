import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/ServiceProvider.dart';
import '../../services/AuthProvider.dart';
import '../../services/dio.dart';
import '../../utils/Constants.dart';
import 'ServiceBookingSuccessScreen.dart';

class ServiceBookingScreen extends StatefulWidget {
  final ServiceProvider serviceProvider;

  const ServiceBookingScreen({Key? key, required this.serviceProvider}) : super(key: key);

  @override
  _ServiceBookingScreenState createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final storage = FlutterSecureStorage();
  late AuthProvider provider;
  late String booking_token = '';
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false); // Fixed listen: false
    readToken();
  }

  void readToken() async {
    try {
      final token = await storage.read(key: 'token');
      if (token != null) {
        provider.tryToken(token: token);
        print("Service Booking Screen");
        print(provider.user?.id);
        if (mounted) {
          setState(() {
            booking_token = token;
          });
        }
      }
    } catch (e) {
      print("Error reading token: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && mounted) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> formData = {
        "customer_id": provider.user?.id.toString() ?? "2", // Fetch from provider
        'service_provider_id': widget.serviceProvider.id.toString(),
        'appointment_date': "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
        'appointment_time': "${_selectedTime.hour}:${_selectedTime.minute}",
      };

      Response response = await dio().post(
        Constants.BASE_URL + Constants.SUBMIT_BOOKING_ROUTE,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $booking_token'}),
      );

      if (response.statusCode == 201 && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookingSuccessScreen(
              serviceName: 'Your service name',
              serviceProviderName: widget.serviceProvider.name,
            ),
          ),
        );
      } else {
        print('Failed to submit booking: ${response.data}');
      }
    } catch (e) {
      print('Error submitting booking: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.person, 'Service Provider:', widget.serviceProvider.name),
                    const Divider(),
                    _infoRow(Icons.calendar_today, 'Selected Date:', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    const SizedBox(height: 10),
                    _dateTimeButton('Select Date', Icons.date_range, () => _selectDate(context)),
                    const Divider(),
                    _infoRow(Icons.access_time, 'Selected Time:', _selectedTime.format(context)),
                    const SizedBox(height: 10),
                    _dateTimeButton('Select Time', Icons.access_time, () => _selectTime(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Book Now', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _dateTimeButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
