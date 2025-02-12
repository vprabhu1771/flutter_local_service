import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/AuthProvider.dart';
import '../../HomeScreen.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String title;

  const ProfileScreen({Key? key, required this.title}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              String avatar = auth.user?.avatar ?? '';
              String name = auth.user?.name ?? '';
              String email = auth.user?.email ?? '';

              return auth.authenticated
                  ? ProfileWidget(
                name: name,
                email: email,
                imageUrl: avatar,
              )
                  : Center(
                child:
                Text('User not authenticated'), // Handle unauthenticated state.
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  ProfileWidget({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(title: 'Edit profile'),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(title: 'Home'),
                ),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}