import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CompatibilityUsers extends StatefulWidget {
  // Create a reference to the database
  final databaseRef = FirebaseDatabase.instance.reference();

  static Set<double> ensemble() {
    final p1 = {
      colours.black,
      colours.yellow,
      colours.violet,
      colours.pink,
      colours.green,
      themes.exotic,
      themes.animals,
      themes.people,
      themes.sports,
    };

    final p2 = {
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

    Set total1_2 = new HashSet.of(p1);
    Set pers1_2 = new HashSet.of(p1);

    total1_2.retainAll(p2);
    pers1_2.addAll(p2);

    double totalInterests1_2 =
        total1_2.length.toDouble() / ((p1.length + p2.length).toDouble() / 2);

    List<double> r1 = [0, 0];

    for (int f = 0; f < 2; f++) {
      Set lot = (f == 0) ? total1_2 : pers1_2;
      for (Enum anEnum in lot) {
        double r1Beginning = r1.elementAt(f);
        String e = anEnum.name;

        var th = themes.values;
        try {
          if (th.contains(themes.valueOf(e))) {
            r1[f] += themes.valueOf(e).getThemes().toDouble();
          }
        } catch (Exception) {}

        if (r1Beginning == r1.elementAt(f)) {
          var co = colours.values;
          try {
            if (co.contains(colours.valueOf(e))) {
              r1[f] += colours.valueOf(e).getColours().toDouble();
            }
          } catch (Exception) {}
        }
      }
    }

    double ort = (r1[0] / r1[1]);

    return {ort, totalInterests1_2};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(children: [
          MaterialButton(onPressed: () async {
            ensemble();
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

  static colours valueOf(String s) {
    return _values[s]!;
  }

  static const _values = {
    'blue': blue,
    'yellow': yellow,
    'red': red,
    'orange': orange,
    'pink': pink,
    'brown': brown,
    'violet': violet,
    'green': green,
    'black': black,
    'white': white,
  };
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

  static themes valueOf(String s) {
    return _values[s]!;
  }

  static const _values = {
    'nature': nature,
    'animals': animals,
    'people': people,
    'architecture': architecture,
    'exotic': exotic,
    'music': music,
    'dance': dance,
    'sports': sports,
    'cuisine': cuisine,
    'technology': technology,
    'cars': cars,
  };
}
