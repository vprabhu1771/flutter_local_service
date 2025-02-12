import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Service.dart';
import '../../models/ServiceProvider.dart';

import '../../utils/Constants.dart';
import 'CallScreen.dart';
import 'ServiceBookingScreen.dart';



class ServiceDetailScreen extends StatefulWidget {
  final String title;
  final Service service;

  const ServiceDetailScreen({Key? key, required this.title, required this.service})
      : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  List<ServiceProvider> serviceProviders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.FILTER_BY_SERVICE + widget.service.id.toString()));

    if (response.statusCode == 200) {
      final List<dynamic> serviceProviderList = json.decode(response.body)['data'];

      setState(() {
        serviceProviders =
            serviceProviderList.map((row) => ServiceProvider.fromJson(row)).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load service providers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : serviceProviders.isEmpty
          ? Center(
        child: Text('No service providers found.'),
      )
          : ListView.builder(
        itemCount: serviceProviders.length,
        itemBuilder: (context, index) {
          final serviceProvider = serviceProviders[index];
          final isAvailable = serviceProvider.serviceStatus.toLowerCase() == 'available';

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Text(
                          serviceProvider.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Service Status: ${serviceProvider.serviceStatus}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isAvailable
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CallScreen(phoneNumber: '6385428910')),
                            );
                          }
                              : null, // Disable the button if service is unavailable
                          icon: Icon(Icons.phone),
                          label: Text('Call Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAvailable ? Colors.greenAccent : Colors.grey, // Change button color based on availability
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: isAvailable
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ServiceBookingScreen(serviceProvider: serviceProvider)),
                            );
                          }
                              : null, // Disable the button if service is unavailable
                          icon: Icon(Icons.event_note),
                          label: Text('Book Service'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAvailable ? Colors.greenAccent : Colors.grey, // Change button color based on availability
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
