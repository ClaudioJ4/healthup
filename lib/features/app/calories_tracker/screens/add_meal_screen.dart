// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthup/constants/front_constants.dart';
import 'package:healthup/features/app/calories_tracker/models/meal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';

class AddMealScreen extends StatelessWidget {
  final String userId;

  AddMealScreen({required this.userId});

  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondBackgroundColor,
        title: Text(
          'Adicionar refeição',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.secondBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextField(
                controller: _mealNameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'Calorias',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
