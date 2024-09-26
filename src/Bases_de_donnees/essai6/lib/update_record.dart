import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecord extends StatefulWidget {

  const UpdateRecord({Key? key, required this.artistsKey}) : super(key: key);

  final String artistsKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {

  final artistNameController = TextEditingController();
  final artistProfilePicController = TextEditingController();
  final artistCreationsNameController = TextEditingController();
  final artistCreationsPicController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Artists');
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.artistsKey).get();

    Map artists = snapshot.value as Map;

    artistNameController.text = artists['name'];
    artistProfilePicController.text = artists['pic'];
    artistCreationsNameController.text = artists['title'];
    artistCreationsPicController.text = artists['creation'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updating record'),
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Updating data in Firebase Realtime Database',
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
                controller: artistCreationsNameController,
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
                  labelText: 'Pic',
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

                  Map<String, String> students = {
                    'name': artistCreationsNameController.text,
                    'pic': artistProfilePicController.text,
                    'title': artistCreationsNameController.text,
                    'creation': artistCreationsPicController.text
                  };

                  dbRef.child(widget.artistsKey).update(students)
                      .then((value) => {
                    Navigator.pop(context)
                  });

                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}