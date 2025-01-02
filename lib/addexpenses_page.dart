import 'package:financialtracker/expenses_page.dart';
import 'package:financialtracker/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final String userId;

  const AddExpensePage({required this.userId, Key? key}) : super(key: key);
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late DatabaseReference _databaseReference;

  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Expenses');
  }

  String? _selectedCategory;
  final _categories = [
    {'icon': Icons.fastfood, 'label': 'Food'},
    {'icon': Icons.health_and_safety, 'label': 'Health'},
    {'icon': Icons.shopping_cart, 'label': 'Shopping'},
    {'icon': Icons.school, 'label': 'Education'},
    {'icon': Icons.travel_explore, 'label': 'Travel'},
    {'icon': Icons.home, 'label': 'Utilities'},
  ];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _addExpense() {
    if (_selectedCategory != null &&
        _amountController.text.isNotEmpty &&
        _dateController.text.isNotEmpty) {
      final expenseData = {
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
        'note': _noteController.text
      };

      _databaseReference.push().set(expenseData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense added successfully!')),
        );
        _clearFields();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add expense: $error')),
        );
      });

      // Use pushAndRemoveUntil to reset the stack and navigate back to HomePage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            (route) => false, // This clears all previous routes
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  void _clearFields() {
    setState(() {
      _selectedCategory = null;
      _amountController.clear();
      _dateController.clear();
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: new IconButton(icon: new Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
          );
        },
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Category', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['label'] as String;
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: _selectedCategory == category['label']
                            ? Color(0xFF024466)
                            : Colors.grey[200],
                        child: Icon(
                          category['icon'] as IconData,
                          color: _selectedCategory == category['label']
                              ? Color(0xFFEDF6FB)
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                          child: Text(category['label'] as String,
                              style: TextStyle(fontSize: 12)
                          )
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF4AC62), // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
