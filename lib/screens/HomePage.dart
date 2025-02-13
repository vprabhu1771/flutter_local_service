import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_service/screens/auth/profile/ProfileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../services/AuthProvider.dart';
import 'CategoryScreen.dart';
import 'SettingScreen.dart';
import 'auth/LoginScreen.dart';
import 'auth/RegisterScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  int _selectedIndex = 0;

  // Titles for each tab
  final List<String> _titles = ["Home", "Category", "Profile"];

  List<String> imagelist = [
    'assets/carousel/appliance.jpg',
    'assets/carousel/bike_mechanic.jpeg',
    'assets/carousel/car mechanic.jpeg',
    'assets/carousel/electrician.jpg',
    'assets/carousel/painter.jpeg',
    'assets/carousel/photographer.jpg',
    'assets/carousel/plumber.jpg',
  ];

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    dynamic token = await storage.read(key: 'token');

    if (token != null) {
      String tokenString = token as String;
      Provider.of<AuthProvider>(context, listen: false).tryToken(token: tokenString);
      print("read token: $tokenString");
    } else {
      print("Token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Dynamic title
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
              onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(title: 'Settings'),
                  ),
                );

              },
              icon: Icon(Icons.settings)
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          Center(
            child: CarouselImages(
              scaleFactor: 0.6,
              listImages: imagelist,
              height: 200.0,
              borderRadius: 30.0,
              cachedNetworkImage: true,
              verticalAlignment: Alignment.topCenter,
              onTap: (index) {
                print('Tapped on page $index');
              },
            ),
          ),
          CategoryScreen(title: 'Category'),
          ProfileScreen(title: 'Profile'),
        ],
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                children: [
                  ListTile(
                    title: Text('Login'),
                    leading: Icon(Icons.login),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen(title: 'Login Screen')),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Register'),
                    leading: Icon(Icons.app_registration),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
                      );
                    },
                  ),
                ],
              );
            } else {
              String avatar = auth.user?.avatar ?? "";
              String name = auth.user?.name ?? "User";
              String email = auth.user?.email ?? "user@example.com";

              return ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                          radius: 30,
                        ),
                        SizedBox(height: 10),
                        Text(name, style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Text(email, style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index); // Sync with PageView
          });
        },
      ),
    );
  }
}
