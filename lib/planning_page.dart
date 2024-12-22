import 'package:flutter/material.dart';

class PlanningPage extends StatelessWidget {
  final String userId;

  const PlanningPage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planning Page"),
      ),
      body: Center(
        child: Text(
          "Welcome to the Planning Page!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
