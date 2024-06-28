// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, unnecessary_cast, avoid_function_literals_in_foreach_calls, avoid_print, prefer_const_constructors_in_immutables, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:healthup/constants/front_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthup/features/app/profile/screens/chart_screen.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? "Usuário";
    final email = user?.email ?? "Email não disponível";

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondBackgroundColor,
        title: Text(
          'Perfil',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                username,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 330,
                child: FirestoreBarChart(userId: user?.uid ?? ''),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Calorias',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Água',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
