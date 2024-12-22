import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3636), // Set custom background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo
            Image.asset(
              'assets/images/logo.png', // Path to your icon
              width: 150, // Adjust size as needed
              height: 150,
            ),
            SizedBox(height: 20),
            // Display app name or slogan
            Text(
              "Financial Tracker",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
