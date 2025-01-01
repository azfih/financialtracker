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
  String userGender = "female";
  String welcomeMessage = "Welcome back! Let's manage your finances.";

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
        userGender = snapshot.child('gender').value as String;
        welcomeMessage = "Hello $userName! Ready to make smarter financial decisions?";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String avatarImage = "assets/images/female.png";
    if (userGender == "male") {
      avatarImage = "assets/images/male.webp";
    } else if (userGender == "other") {
      avatarImage = "assets/images/other.jpeg";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF024466),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.account_circle, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text(
              "Hello, $userName",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeMessage,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(avatarImage),
                  radius: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $userName",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text("Ready to manage your finances?", style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF2FDF2),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Financial Planning",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "A goal without a plan is just a wish. Let's start planning your financial future today!",
                    style: TextStyle(fontSize: 14, color: Color(0xFF7A9872),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTile(
                    title: "Reports",
                    icon: Icons.pie_chart,
                    color: Color(0xFFCAC6DD),
                    text: "Want to check how closely you followed your financial plans? Let's see your reports.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsPage(userId: widget.userId)),
                      );
                    },
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
        backgroundColor: Color(0xFF024466),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: "Income",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
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
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IncomePage(userId: widget.userId)),
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
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        height: 200,
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
