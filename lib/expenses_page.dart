import 'package:flutter/material.dart';

class ExpensesPage extends StatelessWidget {
  final String userId;

  const ExpensesPage({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses Page"),
      ),
      body: Center(
        child: Text(
          "Welcome to the Expenses Page!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
