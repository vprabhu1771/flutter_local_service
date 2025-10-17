import 'package:flutter/material.dart';
import 'package:flutter_local_service/screens/BookingScreen.dart';
import 'package:flutter_local_service/screens/auth/profile/ProfileScreen.dart';
import 'package:provider/provider.dart';

import '../screens/SettingScreen.dart';
import '../screens/auth/LoginScreen.dart';
import '../screens/auth/RegisterScreen.dart';
import '../services/AuthProvider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            String avatar = auth.user?.avatar as String;
            String name = auth.user?.name as String;
            String email = auth.user?.email as String;

            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(avatar),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        name,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
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
                  title: Text('My Profile'),
                  leading: Icon(Icons.verified_user_sharp),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(title: 'Profile'),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Booking'),
                  leading: Icon(Icons.calendar_month),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingScreen(title: 'Bookings'),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Address'),
                  leading: Icon(Icons.pin_drop),
                  onTap: () {
                    // Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(title: 'Settings'),
                      ),
                    );
                  },
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
    );
  }
}