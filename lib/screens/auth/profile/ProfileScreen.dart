import 'package:flutter/material.dart';
import 'package:flutter_local_service/screens/auth/profile/EditProfileScreen.dart';
import 'package:flutter_local_service/screens/auth/profile/ProfileImageUploadScreen.dart';
import 'package:provider/provider.dart';
import '../../../services/AuthProvider.dart';


class ProfileScreen extends StatefulWidget {

  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.authenticated) {
            return const Center(child: Text('Please log in to view your profile.'));
          }

          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user?.avatar ?? 'https://example.com/default-avatar.jpg'),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileImageUploadScreen(title: 'Upload Profile'),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 16),

                // User Name
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user?.name ?? 'No Name'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    // Navigate to edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(title: 'Edit Profile'),
                      ),
                    );
                  },
                ),
                const Divider(),

                // Email
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(user?.email ?? 'No Email'),
                ),
                const Divider(),

                // Phone
                // ListTile(
                //   leading: const Icon(Icons.phone),
                //   title: Text(user?.phone ?? 'No Phone Number'),
                // ),
                // const Divider(),

                // Address
                // ListTile(
                //   leading: const Icon(Icons.location_on),
                //   title: Text(user?.address ?? 'No Address'),
                // ),
                // const Divider(),

                // Logout Button
                TextButton(
                  onPressed: () {
                    authProvider.logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out')),
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}