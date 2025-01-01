import 'package:financialtracker/addincome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  final String userId;

  const IncomePage({required this.userId, Key? key}) : super(key: key);
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage>{
  late DatabaseReference _databaseReference;

  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Income');
    _fetchIncome();
  }

  List<Map<String, dynamic>> _income = [];

  @override

  void _fetchIncome() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> fetchedIncome = [];
        data.forEach((key, value) {
          fetchedIncome.add({
            'id': key,
            'category': value['category'],
            'amount': value['amount'],
            'date': value['date'],
            'note': value['note'] ?? '',
          });
        });

        setState(() {
          _income = fetchedIncome;
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

  void _openAddIncomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddIncomePage(userId: widget.userId)),
    );
  }

  void _showIncomeDetails(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('EIncome Details'),
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
    final groupedIncome = _income.fold<Map<String, List<Map<String, dynamic>>>>({}, (map, income) {
      final dateLabel = _getDateLabel(income['date']);
      if (!map.containsKey(dateLabel)) {
        map[dateLabel] = [];
      }
      map[dateLabel]!.add(income);
      return map;
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _openAddIncomePage,
          ),
        ],
      ),
      body: ListView(
        children: groupedIncome.entries.map((entry) {
          final dateLabel = entry.key;
          final incomes = entry.value;

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
              ...incomes.map((income) {
                final categoryIcon = _getCategoryIcon(income['category']);
                final backgroundColor = _getCategoryColor(income['category']);

                return Card(
                  color: backgroundColor,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(categoryIcon, color: Colors.black),
                    ),
                    title: Text(income['category']),
                    trailing: Text('\$${income['amount'].toStringAsFixed(2)}'),
                    onTap: () => _showIncomeDetails(income),
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
      case 'Salary':
        return Icons.fastfood;
      case 'Rental Pay':
        return Icons.health_and_safety;
      case 'Government':
        return Icons.shopping_cart;
      case 'Allowance':
        return Icons.school;
      case 'Business':
        return Icons.terrain;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Salary':
        return Colors.orange[100]!;
      case 'Rental Pay':
        return Colors.red[100]!;
      case 'Government':
        return Colors.purple[100]!;
      case 'Allowance':
        return Colors.blue[100]!;
      case 'Business':
        return Colors.green[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}

