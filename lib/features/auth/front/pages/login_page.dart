// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, unused_element, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthup/features/auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:healthup/features/auth/front/pages/home_page.dart';
import 'package:healthup/features/auth/front/pages/sign_up_page.dart';
import 'package:healthup/features/auth/front/widgets/form_container_w.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/iconapp.jpg"),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(
              height: 20,
            ),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: _signIn,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 69, 3, 110),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User was signed in");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      print("Error");
    }
  }
}
