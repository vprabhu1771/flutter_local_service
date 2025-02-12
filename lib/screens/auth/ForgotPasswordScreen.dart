import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {

  final String title;

  const ForgotPasswordScreen({super.key, required this.title});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Enter your email to reset password',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your password reset logic here
                // Typically this involves sending a reset link to the provided email
                // or some other method of resetting the password.
                // You can use FirebaseAuth, your own backend API, or any other service.
                // For demonstration purposes, we'll just show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password reset link sent to your email.'),
                  ),
                );
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}