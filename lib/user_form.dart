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
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Users');

  String? _selectedGender;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _dbRef.child(widget.userId).set({
        'name': _nameController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
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
      backgroundColor: Color(0xFF024466),
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
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFFCF4E7)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please provide your details to help us track your financial budget.",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFFFCF4E7)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.white), // Placeholder color
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12)
                    ),
                    style: TextStyle(color: Colors.white),
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
                      labelStyle: TextStyle(color: Colors.white), // Placeholder color
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ), // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    style: TextStyle(color: Colors.white),
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
                      labelStyle: TextStyle(color: Colors.white), // Placeholder color
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ), // White background for fields
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),// White background for fields
                    ),
                    style: TextStyle(color: Colors.grey),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF4AC62),
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
