// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_meal_screen.dart';
import 'change_goal_screen.dart';
import 'view_meals_screen.dart';
import 'package:healthup/constants/front_constants.dart';

class CalorieTrackerScreen extends StatelessWidget {
  final String userId;

  CalorieTrackerScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyCalories')
          .doc(currentDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        int totalCalories = 0;
        int goalCalories = 2000;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          totalCalories = data['totalCalories'] ?? 0;
          goalCalories = data['goalCalories'] ?? 2000;
        }

        final progress = totalCalories / goalCalories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calorias Consumidas: $totalCalories / $goalCalories',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(userId: userId),
                  ),
                );
              },
              child: Text('Adicionar Refeição'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeGoalScreen(userId: userId),
                  ),
                );
              },
              child: Text('Alterar Meta'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewMealsScreen(
                      userId: userId,
                      date: currentDate,
                    ),
                  ),
                );
              },
              child: Text('Visualizar Refeições'),
            ),
          ],
        );
      },
    );
  }
}
