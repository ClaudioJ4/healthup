// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthup/constants/front_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';

class ChangeGoalScreen extends StatelessWidget {
  final String userId;

  ChangeGoalScreen({required this.userId});

  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor:
            AppColors.secondBackgroundColor, // Cor cinza para a AppBar
        title: Text(
          'Alterar meta de calorias',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Título da AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Ícone de logout
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
                controller: _goalController,
                decoration: InputDecoration(
                  labelText: 'Nova Meta de Calorias',
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
