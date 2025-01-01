import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF024466), // Set custom background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo
            Image.asset(
              'assets/images/logo.png', // Path to your icon
              width: 120, // Adjust size as needed
              height: 120,
            ),
            SizedBox(height: 20),
            // Display app name or slogan
            Text(
              "Financial Tracker",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFCF4E7), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
