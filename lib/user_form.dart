import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';

class UserForm extends StatefulWidget {
  final String userId;

  const UserForm({required this.userId, Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _sideEarningsController = TextEditingController();
  final TextEditingController _monthlyExpensesController = TextEditingController();
  final TextEditingController _savingsGoalController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  String? _selectedGender;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _dbRef.child(widget.userId).set({
        'name': _nameController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
        'salary': _salaryController.text,
        'sideEarnings': _sideEarningsController.text,
        'monthlyExpenses': _monthlyExpensesController.text,
        'savingsGoal': _savingsGoalController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome! Let's get your budget plan set up.",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF86A788)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please provide your details to help us track your financial budget.",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF89A8B2)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your age.";
                      }
                      int age = int.tryParse(value) ?? 0;
                      if (age < 18) {
                        return "Age should be above 18.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select your gender.";
                      }
                      return null;
                    },
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                      labelText: "Salary",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your salary.";
                      }
                      double salary = double.tryParse(value) ?? 0;
                      if (salary <= 0) {
                        return "Salary must be greater than zero.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _sideEarningsController,
                    decoration: InputDecoration(
                      labelText: "Side Earnings",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;  // Side earnings can be zero.
                      }
                      double sideEarnings = double.tryParse(value) ?? 0;
                      if (sideEarnings < 0) {
                        return "Side earnings cannot be negative.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _monthlyExpensesController,
                    decoration: InputDecoration(
                      labelText: "Monthly Expenses",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your monthly expenses.";
                      }
                      double expenses = double.tryParse(value) ?? 0;
                      if (expenses <= 0) {
                        return "Monthly expenses must be greater than zero.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _savingsGoalController,
                    decoration: InputDecoration(
                      labelText: "Savings Goal (Optional)",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        double savings = double.tryParse(value) ?? 0;
                        if (savings <= 0) {
                          return "Savings goal must be greater than zero.";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF6B17A),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)), // White text color
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
