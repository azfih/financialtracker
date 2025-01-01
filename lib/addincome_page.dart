import 'package:financialtracker/home_page.dart';
import 'package:financialtracker/income_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddIncomePage extends StatefulWidget {
  final String userId;

  const AddIncomePage({required this.userId, Key? key}) : super(key: key);
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  late DatabaseReference _databaseReference;

  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Income');
  }

  String? _selectedCategory;
  final _categories = [
    {'icon': Icons.business_center, 'label': 'Salary'},
    {'icon': Icons.house, 'label': 'Rental Pay'},
    {'icon': Icons.account_balance, 'label': 'Government'},
    {'icon': Icons.account_balance_wallet, 'label': 'Allowance'},
    {'icon': Icons.business, 'label': 'Business'},
  ];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _addIncome() {
    if (_selectedCategory != null &&
        _amountController.text.isNotEmpty &&
        _dateController.text.isNotEmpty) {
      final incomeData = {
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
        'note': _noteController.text
      };

      _databaseReference.push().set(incomeData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Income added successfully!')),
        );
        _clearFields();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add income: $error')),
        );
      });
      String userId = '';
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IncomePage(userId: widget.userId))
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
      appBar: AppBar(centerTitle: true, title: Text('Add Income', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: new IconButton(icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          },
        ),),
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
                      Text(category['label'] as String, style: TextStyle(fontSize: 12))
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
                onPressed: _addIncome,
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
