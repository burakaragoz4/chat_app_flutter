import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupColleciton =
      FirebaseFirestore.instance.collection("groups");

  // updateing the userdata
  Future updateUserData(String name, String email) async {}
}
