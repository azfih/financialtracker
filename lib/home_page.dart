import 'package:financialtracker/income_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'planning_page.dart';
import 'reports_page.dart';
import 'expenses_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({required this.userId, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String welcomeMessage = "Welcome back! Let's manage your finances.";
  double salary = 0.0;
  double sideEarnings = 0.0;
  double monthlyExpenses = 0.0;
  double savingsGoal = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users').child(widget.userId);

    final snapshot = await userRef.get();

    if (snapshot.exists) {
      setState(() {
        userName = snapshot.child('name').value as String;
        salary = double.tryParse(snapshot.child('salary').value.toString()) ?? 0.0;
        sideEarnings = double.tryParse(snapshot.child('sideEarnings').value.toString()) ?? 0.0;
        monthlyExpenses = double.tryParse(snapshot.child('monthlyExpenses').value.toString()) ?? 0.0;
        savingsGoal = double.tryParse(snapshot.child('savingsGoal').value.toString()) ?? 0.0;

        welcomeMessage = "Hello $userName! Ready to make smarter financial decisions?";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Hello, $userName",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeMessage,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            // Activity Section with Avatar and Financial Info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150", // Placeholder for user profile image
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello $userName", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Salary: \$${salary.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                    Text("Side Earnings: \$${sideEarnings.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                    Text("Monthly Expenses: \$${monthlyExpenses.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                    Text("Savings Goal: \$${savingsGoal.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Quote Tile
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Financial Planning",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "A goal without a plan is just a wish. Let's start planning your financial future today!",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Full-width tiles for other sections
            Expanded(
              child: ListView(
                children: [
                  _buildTile(
                    title: "Reports",
                    icon: Icons.pie_chart,
                    color: Colors.blue.shade100,
                    text: "Want to check how closely you followed your financial plans? Let's see your reports.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsPage(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildTile(
                    title: "Planning",
                    icon: Icons.schedule,
                    color: Colors.orange.shade100,
                    text: "Let's plan your budget and make it fun! We're here to guide you through the process.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanningPage(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildTile(
                    title: "Expenses",
                    icon: Icons.money_off,
                    color: Color(0xFFF4AC62),
                    text: "Track your expenses and keep your budget under control. Let’s manage your spending wisely!",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpensesPage(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildTile(
                    title: "Income",
                    icon: Icons.money_off,
                    color: Color(0xFF7A9872),
                    text: "Track all your sources of income and make smart plans. Let's see your incomes!",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IncomePage(userId: widget.userId)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Planning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: "Expenses",
          ),
        ],
        onTap: (index) {
          // Handle navigation based on index
          if (index == 0) {
            // Home
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsPage(userId: widget.userId)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlanningPage(userId: widget.userId)),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpensesPage(userId: widget.userId)),
            );
          }
        },
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Take full width of the screen
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 150, // Fixed height to make the tiles rectangular
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
