import 'package:flutter/material.dart';
import 'package:habitsmasher/network/network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            habitSmasherTitle(),
            const Text("The new way to create good habits."),
            SignInButton(
              Buttons.google,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
                await signInWithGoogle();
                debugPrint(FirebaseAuth.instance.currentUser.toString());
              },
              text: 'Sign in with Google',
            ),
          ],
        ),
      ),
    );
  }
}

Widget habitSmasherTitle() {
  return const Text(
    'HabitSmasher',
    style: TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),
  );
}
