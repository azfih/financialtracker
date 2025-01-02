import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class ExpenseAnalyticsPage extends StatefulWidget {
  final String userId;

  const ExpenseAnalyticsPage({required this.userId, Key? key}) : super(key: key);

  @override
  _ExpenseAnalyticsPageState createState() => _ExpenseAnalyticsPageState();
}


class _ExpenseAnalyticsPageState extends State<ExpenseAnalyticsPage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> expenses = [];
  Map<String, double> categoryTotals = {};
  Map<String, int> categoryCounts = {};
  Map<String, List<double>> dailyExpenses = {};


  final Map<String, IconData> categoryIcons = {
    'Food': Icons.fastfood,
    'Transport': Icons.directions_car,
    'Shopping': Icons.shopping_cart,
    'Utilities': Icons.lightbulb,
    'Entertainment': Icons.movie,
    'Health': Icons.health_and_safety,
    'Education': Icons.school,
  };


  final List<Color> pieChartColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    final userRef = databaseReference.child("Users").child(widget.userId).child("Expenses");

    final snapshot = await userRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> userExpenses = Map<String, dynamic>.from(
          snapshot.value as Map<dynamic, dynamic>);
      Map<String, double> tempCategoryTotals = {};
      Map<String, int> tempCategoryCounts = {};
      Map<String, List<double>> tempDailyExpenses = {};

      userExpenses.forEach((key, expenseData) {
        String category = expenseData["category"];
        double amount = double.tryParse(expenseData["amount"].toString()) ?? 0;
        String date = expenseData["date"];


        tempCategoryTotals[category] = (tempCategoryTotals[category] ?? 0) + amount;
        tempCategoryCounts[category] = (tempCategoryCounts[category] ?? 0) + 1;


        DateTime expenseDate = DateTime.parse(date);
        String day = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        [expenseDate.weekday - 1];
        tempDailyExpenses.putIfAbsent(day, () => []).add(amount);
      });

      setState(() {
        categoryTotals = tempCategoryTotals;
        categoryCounts = tempCategoryCounts;
        dailyExpenses = tempDailyExpenses;
      });
    }
  }


  double getTotalExpense() {
    return categoryTotals.values.fold(0, (sum, value) => sum + value);
  }

  Map<String, double> getCategoryPercentages() {
    double total = getTotalExpense();
    return categoryTotals.map((key, value) => MapEntry(key, (value / total) * 100));
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = getTotalExpense();
    Map<String, double> categoryPercentages = getCategoryPercentages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Spending Statistics'),
      ),
      body: totalExpense == 0
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Daily Expense Distribution'),
            buildDailyExpensesChart(),
            buildSectionTitle('Category Breakdown'),
            buildCategoryPieChart(categoryPercentages),
            buildSectionTitle('Category Details'),
            buildCategoryDetails(),
            buildViewFurtherDetailsButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
      ),
    );
  }

  Widget buildDailyExpensesChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: BarChart(
          BarChartData(
            barGroups: dailyExpenses.entries.map((entry) {
              String day = entry.key;
              double totalDayExpense =
              entry.value.fold(0, (sum, value) => sum + value);
              return BarChartGroupData(
                x: dailyExpenses.keys.toList().indexOf(day),
                barRods: [
                  BarChartRodData(
                    toY: totalDayExpense,
                    gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: 15,
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Rs. ${value.toInt()}'),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    return Text(dailyExpenses.keys.toList()[index].toString());
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryPieChart(Map<String, double> percentages) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 300,
        child: PieChart(
          PieChartData(
            sections: percentages.entries.map((entry) {
              int index = percentages.keys.toList().indexOf(entry.key);
              return PieChartSectionData(
                value: entry.value,
                color: pieChartColors[index % pieChartColors.length],
                title: '${entry.value.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              );
            }).toList(),
            centerSpaceRadius: 50,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryDetails() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryTotals.length,
      itemBuilder: (context, index) {
        String category = categoryTotals.keys.toList()[index];
        double amount = categoryTotals[category]!;
        int count = categoryCounts[category]!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      categoryIcons[category] ?? Icons.category, // Default icon if not defined
                      color: pieChartColors[index % pieChartColors.length],
                    ),
                    SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total: Rs. ${amount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Count: $count',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildViewFurtherDetailsButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseDetailPage()),
            );
          },
          child: Text('View Further Details'),
        ),
      ),
    );
  }
}

class ExpenseDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: Center(
        child: Text('Detailed expense information will be displayed here.'),
      ),
    );
  }
}
