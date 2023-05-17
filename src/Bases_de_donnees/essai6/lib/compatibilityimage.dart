// @dart=2.9

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';

class CompatibilityImage extends StatefulWidget {
  // Create a reference to the database
  final databaseRef = FirebaseDatabase.instance.reference();

  static double total(Set base, Set p2) {
    List lor = [
      [0, 0, 0],
      [0, 0, 255],
      [0, 255, 0],
      [255, 0, 0],
      [255, 255, 255],
    ];

    List d1 = [];
    var m1 = 0;

    for (List x in base) {
      d1 = [];
      for (List f in lor) {
        int counter = 0;
        for (int i = 0; i < f.length; i++) {
          counter += (f[i] - x[i]).abs();
        }
        d1.add(counter);
      }
      d1.sort();
      m1 += d1[d1.length - 1];
    }

    List d2 = [];
    var m2 = 0;

    for (List x in base) {
      d2 = [];
      for (List f in p2) {
        int counter = 0;
        for (int i = 0; i < f.length; i++) {
          counter += (f[i] - x[i]).abs();
        }
        d2.add(counter);
      }
      d2.sort();
      m2 += d2[0];
    }

    double ort = 1 - (m2 / m1);

    return ort;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(children: [MaterialButton(onPressed: () async {})]),
      ),
    ));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}