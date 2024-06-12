import 'package:flutter/material.dart';
import 'package:location/location.dart';

/// Catch-all file for things like extensions enums and other various things

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DateTimeExtension on DateTime {
  String format() {
    return toString().substring(0, 10);
  }
}

enum Operation { add, edit }

extension LocationExtension on LocationData {
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

void showException(BuildContext context, Exception e) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      });
}

OutlineInputBorder textFieldBorder() {
  return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown),
      borderRadius: BorderRadius.all(Radius.circular(20)));
}

// TODO: implement inputDecoration for all text fields
InputDecoration inputDecoration({required String labelText, String? hintText}) {
  return InputDecoration(
    border: textFieldBorder(),
    focusedBorder: textFieldBorder(),
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.brown),
    hintText: hintText,
  );
}
