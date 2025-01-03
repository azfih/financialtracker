import 'package:financialtracker/addexpenses_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  final String userId;

  const ExpensesPage({required this.userId, Key? key}) : super(key: key);
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late DatabaseReference _databaseReference;

  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Expenses');
        _fetchExpenses();
  }

  List<Map<String, dynamic>> _expenses = [];

  @override

  void _fetchExpenses() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> fetchedExpenses = [];
        data.forEach((key, value) {
          fetchedExpenses.add({
            'id': key,
            'category': value['category'],
            'amount': value['amount'],
            'date': value['date'],
            'note': value['note'] ?? '',
          });
        });

        setState(() {
          _expenses = fetchedExpenses;
        });
      }
    });
  }

  String _getDateLabel(String date) {
    final today = DateTime.now();
    final dateTime = DateFormat('yyyy-MM-dd').parse(date);
    final difference = today.difference(dateTime).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(dateTime);
    }
  }

  void _openAddExpensePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpensePage(userId: widget.userId)),
    );
  }

  void _showExpenseDetails(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Expense Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${expense['category']}'),
              Text('Amount: \$${expense['amount']}'),
              Text('Date: ${expense['date']}'),
              if (expense['note'].isNotEmpty) Text('Note: ${expense['note']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpenses = _expenses.fold<Map<String, List<Map<String, dynamic>>>>({}, (map, expense) {
      final dateLabel = _getDateLabel(expense['date']);
      if (!map.containsKey(dateLabel)) {
        map[dateLabel] = [];
      }
      map[dateLabel]!.add(expense);
      return map;
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _openAddExpensePage,
          ),
        ],
      ),
      body: ListView(
        children: groupedExpenses.entries.map((entry) {
          final dateLabel = entry.key;
          final expenses = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateLabel,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ...expenses.map((expense) {
                final categoryIcon = _getCategoryIcon(expense['category']);
                final backgroundColor = _getCategoryColor(expense['category']);

                return Card(
                  color: backgroundColor,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(categoryIcon, color: Colors.black),
                    ),
                    title: Text(expense['category']),
                    trailing: Text('\$${expense['amount'].toStringAsFixed(2)}'),
                    onTap: () => _showExpenseDetails(expense),
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Health':
        return Icons.health_and_safety;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Education':
        return Icons.school;
      case 'Travel':
        return Icons.terrain;
      case 'Utilities':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Color(0xFFF4AC62);
      case 'Health':
        return Color(0xFFDB5E60);
      case 'Shopping':
        return Color(0xFF615599);
      case 'Education':
        return Color(0xFF44A5C3);
      case 'Travel':
        return Color(0xFF7A9872);
      case 'Utilities':
        return Color(0xFF);
      default:
        return Color(0xFF);
    }
  }
}

