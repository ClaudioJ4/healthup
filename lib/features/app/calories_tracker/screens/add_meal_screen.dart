// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthup/features/app/calories_tracker/models/meal.dart';

class AddMealScreen extends StatelessWidget {
  final String userId;

  AddMealScreen({required this.userId});

  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar refeição'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mealNameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: 'Calorias'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final meal = Meal(
                  id: '',
                  name: _mealNameController.text,
                  calories: int.parse(_caloriesController.text),
                );
                addMeal(userId, meal);
                Navigator.pop(context);
              },
              child: Text('Adicionar refeição'),
            ),
          ],
        ),
      ),
    );
  }

  void addMeal(String userId, Meal meal) {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final mealRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyCalories')
        .doc(date)
        .collection('meals')
        .doc();

    mealRef.set(meal.toMap());

    final userDayRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyCalories')
        .doc(date);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDayRef);

      if (snapshot.exists) {
        final totalCalories = snapshot['totalCalories'] ?? 0;
        transaction.update(userDayRef, {
          'totalCalories': totalCalories + meal.calories,
        });
      } else {
        transaction.set(userDayRef, {
          'totalCalories': meal.calories,
          'goalCalories': 2000,
        });
      }
    });
  }
}
