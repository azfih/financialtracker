import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class PlanningPage extends StatefulWidget {
  final String userId;

  const PlanningPage({required this.userId, Key? key}) : super(key: key);

  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  late DatabaseReference _budgetReference;
  late DatabaseReference _expensesReference;

  double? totalBudget;
  double dailyLimit = 0.0;
  Map<String, double> dailyExpenses = {};
  List<Map<String, dynamic>> todayExpenses = [];

  @override
  void initState() {
    super.initState();
    _budgetReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Budget');
    _expensesReference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.userId)
        .child('Expenses');
    _fetchBudget();
    _fetchExpenses();
  }

  void _fetchBudget() {
    _budgetReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          totalBudget = double.tryParse(data['totalBudget'].toString()) ?? 0.0;
          dailyLimit = totalBudget! / _daysInCurrentMonth();
        });
      }
    });
  }

  void _fetchExpenses() {
    _expensesReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> fetchedExpenses = [];
        data.forEach((key, value) {
          fetchedExpenses.add({
            'id': key,
            'category': value['category'],
            'amount': double.tryParse(value['amount'].toString()) ?? 0.0,
            'date': value['date'],
            'note': value['note'] ?? '',
          });
        });

        // Filter today's expenses
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final Map<String, double> expensesByDate = {};
        fetchedExpenses.forEach((expense) {
          final date = expense['date'];
          final amount = expense['amount'];

          if (expensesByDate.containsKey(date)) {
            expensesByDate[date] = expensesByDate[date]! + amount;
          } else {
            expensesByDate[date] = amount;
          }
        });

        setState(() {
          todayExpenses = fetchedExpenses.where((expense) => expense['date'] == today).toList();
          dailyExpenses = expensesByDate;
        });
      }
    });
  }

  int _daysInCurrentMonth() {
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }


  void _addOrEditBudget() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController budgetController = TextEditingController(
            text: totalBudget != null ? totalBudget!.toString() : '');
        return AlertDialog(
          title: Text(totalBudget == null ? 'Set Budget' : 'Edit Budget'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter total monthly budget'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text);
                if (budget != null) {
                  _budgetReference.set({'totalBudget': budget});
                  setState(() {
                    totalBudget = budget;
                    dailyLimit = budget / _daysInCurrentMonth();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todaySpent = dailyExpenses[today] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Budget Planning",
          style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addOrEditBudget,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: totalBudget == null
            ? Center(
          child: Text(
            'No budget set. Click the "+" button to create your budget.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              color: Color(0xFF024466),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Planned",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              "\$${totalBudget!.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Spent",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              "\$${todaySpent.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Remaining",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              "\$${(dailyLimit - todaySpent).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Daily Limit: \$${dailyLimit.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display today's expenses beneath daily limit
            if (todayExpenses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Today\'s Expenses:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ...todayExpenses.map((expense) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(expense['category']),
                  subtitle: Text(expense['note']),
                  trailing: Text('\$${expense['amount'].toStringAsFixed(2)}'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}