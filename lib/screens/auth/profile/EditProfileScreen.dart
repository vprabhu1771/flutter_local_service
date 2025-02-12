import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String title;

  const EditProfileScreen({Key? key, required this.title}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Assuming you have access to the current user's details, populate the text fields with the user's current details
    // For example:
    _nameController.text = 'John Doe'; // Replace 'John Doe' with the current user's name
    _emailController.text = 'john.doe@example.com'; // Replace 'john.doe@example.com' with the current user's email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform profile update logic here
                String newName = _nameController.text;
                String newEmail = _emailController.text;
                // Update the profile with the new name and email
                // You can call a function to update the profile with the new details
                // For example: updateProfile(newName, newEmail);
                // Once the update is successful, you can navigate back to the profile screen
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
