import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sign_up_page.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'Financial Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashTransition(),
    );
  }
}

class SplashTransition extends StatefulWidget {
  @override
  _SplashTransitionState createState() => _SplashTransitionState();
}

class _SplashTransitionState extends State<SplashTransition> {
  @override
  void initState() {
    super.initState();
    // Navigate to SignUpPage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
