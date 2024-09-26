import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });


  final CollectionReference artemCollection = FirebaseFirestore.instance.collection('donnees_images');

  Future updateUserData(String nom_artiste, String image_avatar, String description_image, String url_image) async {
    return await artemCollection.doc(uid).set({
      'nom_artiste': nom_artiste,
      'image_avatar': image_avatar,
      'decription_image': description_image,
      'url_image': url_image,
    });
  }
}
