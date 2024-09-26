import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';

class CompatibilityImage extends StatefulWidget {
  // Create a reference to the database
  final databaseRef = FirebaseDatabase.instance.reference();

  static double total() {
    final image = {
      colours.black: 90 * colours.black.getColours(),
      colours.green: 2 * colours.green.getColours(),
      colours.violet: 1 * colours.violet.getColours(),
      themes.nature: 59 * themes.nature.getThemes(),
      themes.animals: 59 * themes.animals.getThemes(),
      themes.dance: 59 * themes.dance.getThemes(),
    };

    final p1 = {
      colours.blue,
      colours.yellow,
      colours.violet,
      colours.pink,
      colours.green,
      themes.exotic,
      themes.animals,
      themes.people,
      themes.sports,
    };

    double som = 0.0, den = 0.0;

    for (Enum value in p1) {
      try {
        som += image[value]!.toInt();
      } catch (Exception) {}
    }

    final arr = (image.values);
    for (int i = 0; i < arr.length; i++) {
      den += arr.elementAt(i);
    }

    return (som / den);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(children: [
          MaterialButton(onPressed: () async {
            total();
          })
        ]),
      ),
    ));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

enum colours {
  blue(1),
  yellow(1),
  red(1),
  orange(1),
  pink(1),
  brown(1),
  violet(1),
  green(1),
  black(1),
  white(1);

  final value;
  const colours(this.value);
  int getColours() {
    return value;
  }
}

enum themes {
  nature(18),
  animals(17),
  people(19),
  architecture(16),
  exotic(17),
  music(15),
  dance(15),
  sports(15),
  cuisine(14),
  technology(15),
  cars(16);

  final value;
  const themes(this.value);
  int getThemes() {
    return value;
  }
}
