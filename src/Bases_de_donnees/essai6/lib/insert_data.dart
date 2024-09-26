import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {

  final artistNameController = TextEditingController();
  final artistProfilePicController = TextEditingController();
  final artistCreationsNameController = TextEditingController();
  final artistCreationsPicController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Artists');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserting data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Inserting data in Firebase Realtime Database',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: artistNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: artistProfilePicController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Image',
                  hintText: 'Enter link',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: artistCreationsNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  hintText: 'Enter title',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: artistCreationsPicController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Image',
                  hintText: 'Enter link',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> artists = {
                    'name': artistNameController.text,
                    'pic': artistProfilePicController.text,
                    'title': artistCreationsNameController.text,
                    'creation': artistCreationsPicController.text
                  };

                  dbRef.push().set(artists);

                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Insert Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}