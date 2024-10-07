
import 'package:cloud_firestore/cloud_firestore.dart';
class CommentModel {
  String profilePhoto;
  String id;
  String uid;
  String username;
  String comment;
  // ignore: prefer_typing_uninitialized_variables
  final date;
  List likes;
  CommentModel({
    required this.profilePhoto,
    required this.id,
    required this.uid,
    required this.username,
    required this.comment,
    required this.date,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'profilePhoto': profilePhoto});
    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'comment': comment});
    result.addAll({'date': date});
    result.addAll({'likes': likes});

    return result;
  }

  factory CommentModel.fromSnap(DocumentSnapshot snap) {
    var map = snap.data()! as Map<String, dynamic>;
    return CommentModel(
      profilePhoto: map['profilePhoto'] ,
      id: map['id'] ,
      uid: map['uid'] ,
      username: map['username'] ,
      comment: map['comment'] ,
      date: map['date'],
      likes: List.from(map['likes']),
    );
  }

  @override
  String toString() {
    return 'CommentModel(profilePhoto: $profilePhoto, id: $id, uid: $uid, username: $username, comment: $comment, date: $date, likes: $likes)';
  }

}
