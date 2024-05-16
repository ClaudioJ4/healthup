// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Color.fromARGB(255, 40, 38, 40),
        child: ListView(
          children: [
            Text(
              "Home Page",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 69, 3, 110),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
