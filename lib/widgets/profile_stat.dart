import 'package:flutter/material.dart';

Widget profileStat(String label, int value) {
  return Column(
    children: [
      Text(
        '$value',
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4.0),
      Text(
        label,
        style: const TextStyle(fontSize: 16.0, color: Colors.grey),
      ),
    ],
  );
}
