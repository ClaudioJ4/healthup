// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthup/constants/front_constants.dart';

class ChangeGoalScreen extends StatelessWidget {
  final String userId;

  ChangeGoalScreen({required this.userId});

  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Meta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Nova Meta de Calorias'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newGoal = int.parse(_goalController.text);
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('dailyCalories')
                    .doc(DateTime.now().toIso8601String().substring(0, 10))
                    .set({'goalCalories': newGoal}, SetOptions(merge: true));
                Navigator.pop(context);
              },
              child: Text('Alterar Meta'),
            ),
          ],
        ),
      ),
    );
  }
}
