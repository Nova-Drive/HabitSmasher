import 'package:flutter/material.dart';
import 'package:location/location.dart';

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

BorderRadius textFieldBorderRadius = BorderRadius.circular(20);

extension LocationExtension on LocationData {
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
