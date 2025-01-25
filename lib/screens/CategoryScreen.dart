import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Category.dart';
import '../utils/Constants.dart';

class CategoryScreen extends StatefulWidget {

  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  late List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.CATEGORY_ROUTE));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        if (mounted) {
          setState(() {
            categories = data.map((category) => Category.fromJson(category)).toList();
          });
        }
      } else {
        throw Exception('Failed to load categories ' + Constants.BASE_URL + Constants.CATEGORY_ROUTE);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> onRefresh() async {
    await fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                print(categories[index].name);

                print(categories[index].icon_path);

              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      categories[index].icon_path,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      categories[index].name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
