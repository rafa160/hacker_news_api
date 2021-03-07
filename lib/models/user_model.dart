import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  String id;
  String email;

  UserModel({this.id, this.email});

  UserModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    email = snapshot.data['email'];
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
  };

}