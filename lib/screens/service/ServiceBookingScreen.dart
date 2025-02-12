import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../models/ServiceProvider.dart';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:provider/provider.dart';

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


  late String booking_token;

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    try {
      final token = await storage.read(key: 'token');


      if (token != null) {
        final tokenString = token as String;

        Provider.of<AuthProvider>(context, listen: false).tryToken(token: tokenString);

        print("Token read successfully: $tokenString");

        booking_token = tokenString;
      } else {
        print("Token is null");
      }
    } catch (e) {
      print("Error reading token: $e");
    }
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Service'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5.0,
              color: Colors.black38, // Change card color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Service Provider:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.serviceProvider.name,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Date:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent, // Change button color here
                          ),
                          child: Text('Select Date'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Time:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent, // Change button color here
                          ),
                          child: Text('Select Time'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Selected Time: ${_selectedTime.format(context)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {

                _submitBoking();


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text('Book Now', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitBoking() async {

    try {

      // Define your headers
      Map<String, String> headers = {
        'Content-Type': 'application/json', // Example header
        'Authorization': 'Bearer $booking_token', // Example authorization header
      };

      // Print selected date
      print(_selectedTime.toString());

      // Format the time
      // String formattedTime = DateFormat('H:m').format(_selectedTime.toString());
      // print(formattedTime);

      Map<String, String> formData = {
        'service_provider_id': widget.serviceProvider.id.toString(),
        'appointment_date': "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
        'appointment_time': "${_selectedTime.hour}:${_selectedTime.minute}",
      };

      print(_selectedDate.toString());

      // Make a POST request to submit the feedback
      Response response = await dio().post(
        Constants.BASE_URL + Constants.SUBMIT_BOOKING_ROUTE,
        data: formData,
        options: Dio.Options(headers: {'Authorization': 'Bearer $booking_token'}),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 201) {
        // Optionally, you can parse the response or handle it in any way you need
        print('Feedback submitted successfully');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookingSuccessScreen(
              serviceName: 'Your service name', // Replace 'Your service name' with the actual service name
              serviceProviderName: widget.serviceProvider.name,
            ),
          ),
        );

      } else {
        print('Failed to submit booking. Status code: ${response.statusCode} ${response.data}');
        // Optionally, you can show an error dialog
      }
    } catch (e) {
      print('Error submitting booking: $e');
      // Optionally, you can show an error dialog

      if (e is DioError) {
        // Handle Dio errors, which include more information about the response
        print('DioError during Login: ${e.response?.statusCode} ${e.response?.data}');
      } else {
        // Handle other types of errors
        print('Error during Login: $e');
      }
    }
  }

}
