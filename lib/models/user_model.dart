import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String profilePhoto;
  String email;
  String bio;
  String uid;

  UserModel({
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.bio,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'profilePhoto': profilePhoto,
        'email': email,
        'bio': bio,
        'uid': uid,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        name: snapshot['name'],
        profilePhoto: snapshot['profilePhoto'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        uid: snapshot['uid']);
  }
  static UserModel fromJson(Map<String, dynamic> snapshot) {
    return UserModel(
        name: snapshot['name'],
        profilePhoto: snapshot['profilePhoto'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        uid: snapshot['uid']);
  }
}
