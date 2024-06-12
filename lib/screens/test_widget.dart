import "package:flutter/material.dart";
import 'package:habitsmasher/network/network.dart';
import 'package:habitsmasher/screens/login_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final List<HabitEvent> habitEvents = sampleHabitEvents;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Comments are here to help understand processes

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("logout"),
        onPressed: () async {
          await signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        },
      ),
    );
  }
}
