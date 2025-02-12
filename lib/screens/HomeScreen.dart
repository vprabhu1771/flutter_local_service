import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';


import '../services/AuthProvider.dart';
import 'CategoryScreen.dart';
import 'auth/LoginScreen.dart';
import 'auth/RegisterScreen.dart';


class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageController _pageController = PageController();

  List<String> imagelist = [
    'assets/carousel/appliance.jpg',
    'assets/carousel/bike_mechanic.jpeg',
    'assets/carousel/car mechanic.jpeg',
    'assets/carousel/electrician.jpg',
    'assets/carousel/painter.jpeg',
    'assets/carousel/photographer.jpg',
    'assets/carousel/plumber.jpg',
  ];

  final storage = new FlutterSecureStorage();


  @override
  void initState() {
    super.initState();

    readToken();
  }

  void readToken() async {
    dynamic token = await this.storage.read(key: 'token');

    if (token != null) {
      // Explicitly cast the token to a String
      String tokenString = token as String;

      Provider.of<AuthProvider>(context, listen: false).tryToken(token: tokenString);

      print("read token");
      print(tokenString);

    } else {
      print("Token is null");
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
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
          CategoryScreen(title: 'Category'),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if(!auth.authenticated)
            {
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
                        // Handle logout logic
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
                        );
                      },
                    ),
                  ]
              );
            }
            else
            {
              String avatar = auth.user?.avatar as String;
              String name = auth.user?.name as String;
              String email = auth.user?.email as String;

              return ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [

                        CircleAvatar(
                          // backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(avatar),
                          radius: 30,
                        ),

                        SizedBox(height: 10,),

                        Text(
                          name,
                          style: TextStyle(color: Colors.white),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          email,
                          style: TextStyle(color: Colors.white),
                        ),

                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      // Handle logout logic
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    },
                  ),
                ],
              );
            }

          },
        ),
      ),
    );
  }
}
