// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthup/features/app/calendar/screens/calendar_screen.dart';
import 'package:healthup/features/app/calories_tracker/screens/calorie_tracker_screen.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';
import 'package:healthup/constants/front_constants.dart';
import 'package:healthup/features/app/water_tracker/screens/water_tracker_screen.dart';
import 'package:healthup/features/app/profile/screens/profile_screen.dart';
import 'package:healthup/features/app/calendar/widgets/exercise_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondBackgroundColor,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    user?.displayName ?? 'Perfil',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 40),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        color: AppColors.backgroundColor,
        child: ListView(
          children: [
            Text(
              "Health UP!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.secondBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: user != null
                  ? CalorieTrackerScreen(userId: user.uid)
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.secondBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: user != null
                  ? WaterTrackerScreen(userId: user.uid)
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.secondBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exercicios marcados para hoje:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  user != null ? ExerciseList(userId: user.uid) : SizedBox(),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Ver Calendário',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
