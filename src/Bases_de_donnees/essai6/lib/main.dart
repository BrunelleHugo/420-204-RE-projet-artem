// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:essai6/compatibilityimage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_image/flutter_image.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chalkdart/chalk.dart';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:color_extract/color_extract.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:essai6/compatibilityimage.dart';
import 'package:essai6/compatibilityusers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green[100],
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green),
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PaletteGenerator _paletteGenerator;

// Strings to store the extracted Article titles
  String result1 = 'Result 1';

  final String url =
      'https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/51fidJPxdzL._AC_SX466_.jpg';

// boolean to show CircularProgressIndication
// while Web Scraping awaits
  bool isLoading = false;

  Uint8List uint;

  List<int> users = [
    236057,
    405418,
    283153,
    42651,
    8102,
    18401,
    302,
    618199,
    503,
    400553,
    726323
  ];
  String directory =
      'C:/Users/chris/Documents/GitHub/420-204-RE-projet-artem/src/Bases_de_donnees/essai6';

  Future<File> saveNetworkImageToFile(String imageUrl, String fileName) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = (response.statusCode == 200) ? response.bodyBytes : null;

    final imageFile = File('$directory/$fileName');

    await imageFile.writeAsBytes(bytes);

    Image im = Image.file(imageFile);

    ImageProvider imPro = im.image;

    var paletteGenerator = await PaletteGenerator.fromImageProvider(imPro);

    var colors = paletteGenerator.colors;

    for (Color col in colors) {
      print(chalk.rgb(col.red, col.green, col.blue)(col.toString()));
    }

    //print(imageFile);

    return imageFile;
  }

  Future<void> _myGeneratePalette(int counter) async {
    Image im = Image(
      image: AssetImage("images/chat1.jpg"),
      height: 224,
      width: 348,
    );

    ImageProvider imPro = im.image;

    _paletteGenerator = await PaletteGenerator.fromImageProvider(imPro);

    var colors = _paletteGenerator.colors.elementAt(counter);

    var red = colors.red;
    var green = colors.green;
    var blue = colors.blue;
    var alpha = colors.alpha;

    img.ColorRgb8 c = img.ColorRgb8(red, green, blue);

    String cd = ('#${colors.red + colors.green + colors.blue}');

    //print(red.toString() + ":" + green.toString() + ":" + blue.toString());
    //print(c.data);
    print(chalk.rgb(red, green, blue)("YES"));
  }

  /* Future<void> _detectObjects() async {
    FirebaseVisionObjectDetectorOptions options =
        new FirebaseVisionObjectDetectorOptions.Builder()
                .setDetectorMode(FirebaseVisionObjectDetectorOptions.SINGLE_IMAGE_MODE)
                .enableMultipleObjects()
                .enableClassification()  // Optional
                .build();
    final imageFile = await File('$im');
    if (imageFile != null) {
      final inputImage = InputImage.fromFile(imageFile);
      final objectDetector = GoogleMlKit.instance.objectDetector();
      final RecognisedObjectList objects =
          await objectDetector.processImage(inputImage);
      // Use the detected objects in your app
    }
  } */

  Future<List<String>> extractData(int k) async {
    // Getting the response from the targeted url
    final response = await http.Client().get(Uri.parse(
        'http://www.saatchiart.com/account/artworks/${users.elementAt(k)}'));

    /* DatabaseReference db =
        FirebaseDatabase.instance.ref("users/" + users.elementAt(k).toString()); */

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);
      int counter = 0;
      try {
        // Scraping the first article title
        List list = [];
        var classlor = document
            .getElementsByClassName("sc-1ypbzzj-4 sc-9pmg3r-2 cgnOZJ kpSjBp");
        var usagers = document.getElementsByTagName('img');
        var nom, avatar;

        for (var usager in usagers) {
          var fl = usager.attributes['src'];

          if (fl != null && fl.contains(RegExp(r'^http.*\.(jpg|png|jpeg)'))) {
            nom = usager.attributes['alt'];
            avatar = usager.attributes['src'];
            break;
          }
        }
        list.add(nom);
        list.add(avatar);

        for (var h = 0; h < classlor.length; h++) {
          var oeuvre, dimension, imageUrl;
          var case1 = classlor[h].children[0];
          var img = case1.getElementsByTagName("img");
          var h2 = case1.getElementsByTagName("h2");
          var h4 = case1.getElementsByTagName("h4")[0].children;

          for (var image in img) {
            imageUrl = (image.attributes['src'] != null)
                ? image.attributes['src']
                : image.attributes['data-src'];
          }

          for (var h21 in h2) {
            oeuvre ??= h21.text;
          }

          for (var h41 in h4) {
            dimension ??= h41.text;
          }

          if (imageUrl != null) {
            if (imageUrl.startsWith(RegExp(r'^http.*\.(jpg|png|jpeg)'))) {
              counter++;

              saveNetworkImageToFile(imageUrl, "image" + counter.toString());

              //await _myGeneratePalette(counter);
              //print(_paletteGenerator.colors.map((color) {return Container(color: color);}).toList());

              /* var paletteGenerator = await generatePalette(imageUrl);
              print(paletteGenerator.value); */

              //print(CompatibilityImage.total());

              print("ort: ${CompatibilityUsers.ensemble().elementAt(0)}");
              print(
                  "totalInterests1_2: ${CompatibilityUsers.ensemble().elementAt(1)}");

              list.add(counter);
              list.add(oeuvre);
              list.add(imageUrl.toString());
              list.add(dimension);
            }
          }
        }

        //print(list.toString());

        return [nom.toString()];
      } catch (Exception) {
        return ['', '', 'ERROR!'];
      }
    }
    return ['', '', 'ERROR STATUS CODE WASNT 200!'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if isLoading is true show loader
            // else show Column of Texts
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Text(result1,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ],
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            MaterialButton(
              onPressed: () async {
                // Setting isLoading true to show the loader
                setState(() {
                  isLoading = true;
                });

                final response = [];
                // Awaiting for web scraping function
                // to return list of strings
                for (int k = 0; k < users.length; k++) {
                  response.add(await extractData(k));
                }

                // Setting the received strings to be
                // displayed and making isLoading false
                // to hide the loader
                setState(() {
                  result1 = response[0];
                  isLoading = false;
                });
              },
              color: Colors.green,
              child: const Text(
                'Scrap Data',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        )),
      ),
    );
  }
}
