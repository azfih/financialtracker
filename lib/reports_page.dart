import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  final String userId;

  const ReportsPage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports Page"),
      ),
      body: Center(
        child: Text(
          "Welcome to the Reports Page!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
