// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_water_screen.dart';
import 'change_water_goal_screen.dart';
import 'package:healthup/constants/front_constants.dart';

class WaterTrackerScreen extends StatelessWidget {
  final String userId;

  WaterTrackerScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyWaterIntake')
          .doc(currentDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        Map<String, dynamic>? data;
        int totalWaterIntake = 0;
        int goalWaterIntake = 2000;

        if (snapshot.hasData && snapshot.data!.exists) {
          data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null) {
            totalWaterIntake = data['totalWaterIntake'] ?? 0;
            goalWaterIntake = data['goalWaterIntake'] ?? 2000;
          }
        }

        final progress = totalWaterIntake / goalWaterIntake;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Água Ingerida: $totalWaterIntake ml / $goalWaterIntake ml',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.backgroundColor,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddWaterScreen(userId: userId),
                          ),
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text('Adicionar Água'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeWaterGoalScreen(userId: userId),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text('Alterar Meta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
