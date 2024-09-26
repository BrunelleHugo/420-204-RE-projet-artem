// @dart=2.9

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.green,
      scaffoldBackgroundColor: Colors.green[100],
      primaryColor: Colors.green,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// Strings to store the extracted Article titles
  String result1 = 'Result 1';
  var imageUrl;

// boolean to show CircularProgressIndication
// while Web Scraping awaits
  bool isLoading = false;

  Future<List<String>> extractData() async {
    // Getting the response from the targeted url
    final response = await http.Client()
        .get(Uri.parse('http://www.saatchiart.com/account/artworks/742148'));

    // Status Code 200 means response has been received successfully

    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);
      try {
        // Scraping the first article title
        print("1");
        var classElement = document.getElementsByClassName("sc-1ybxa11-1 Utusx");
        // print(idElement.length);
        for (var i = 0; i < classElement.length; i++) {
          print(i);

          var image = classElement[i];
          var a = image.getElementsByTagName("a");
          var href = a[0].attributes["href"];
          var name = a[0].text;

          var dimensions = image.getElementsByTagName("span");
          var dimension = dimensions[0].text;

          if (!href.toString().contains("http")) {
            print(name);
            print("https://www.saatchiart.com" + href);
            print(dimension);
          }

          // var link1 = image.attributes;
          // imageUrl = image.attributes["data-src"];
          // print(link1);
          // print(imageUrl.toString());

          // if (imageUrl.endsWith(".jpg")){
          //   print(name + ": " + imageUrl);
          //   //await downloadAndSaveImage(imageUrl, filePath);
          // }
        }

        //print(idElement);

        return ["result1.toString()"];
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    }
  }

  // Future<void> downloadAndSaveImage(String url, String fileName) async {
  //   final response = await http.get(Uri.parse(url));
  //   final file = File('$fileName.glb');
  //   await file.writeAsBytes(response.bodyBytes);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GeeksForGeeks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if isLoading is true show loader
            // else show Column of Texts
            isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(result1,
                          style: TextStyle(
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

                // Awaiting for web scraping function
                // to return list of strings
                final response = await extractData();

                // Setting the received strings to be
                // displayed and making isLoading false
                // to hide the loader
                setState(() {
                  result1 = response[0];
                  isLoading = false;
                });
              },
              child: Text(
                'Scrap Data',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            )
          ],
        )),
      ),
    );
  }
}
