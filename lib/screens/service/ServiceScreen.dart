import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../screens/service/ServiceDetailScreen.dart';
import '../../models/Category.dart';
import '../../models/Service.dart';
import '../../utils/Constants.dart';

class ServiceScreen extends StatefulWidget {
  final String title;
  final Category category;

  const ServiceScreen({Key? key, required this.title, required this.category})
      : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {

  late List<Category> categories = [];

  late List<Category> filteredCategories = [];

  late List<Service> services = [];

  late List<Service> filteredServices = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          Constants.BASE_URL + Constants.SERVICES_ROUTE + widget.category.id.toString()));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        if (mounted) {
          setState(() {
            services = data.map((row) => Service.fromJson(row)).toList();
            filteredServices = services; // Initialize filtered list
          });
        }

      } else {
        throw Exception(
            'Failed to load services ' + Constants.BASE_URL + Constants.SERVICES_ROUTE);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToServiceDetailScreen(Service selectedService) {
    // Implement navigation to product screen
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceDetailScreen(title: 'Service Detail', service: selectedService,)),
    );
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  void filterServices(String query) {
    setState(() {
      filteredServices = services
          .where((service) => service.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterServices,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: filteredServices.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      navigateToServiceDetailScreen(filteredServices[index]);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredServices[index].name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Description Section UI
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filteredServices[index].description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     navigateToServiceDetailScreen(filteredServices[index]);
                            //   },
                            //   child: Text(
                            //     'View Details',
                            //     style: TextStyle(fontSize: 14),
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.greenAccent,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
