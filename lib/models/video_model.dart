import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VideoModel {
  String id;
  String uid;
  String username;
  List likes;
  int commentCount;
  int shareCount;
  String caption;
  String videoUrl;
  String thumnail;
  String profilePhoto;
  VideoModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.caption,
    required this.videoUrl,
    required this.thumnail,
    required this.profilePhoto,
  });

  VideoModel copyWith({
    String? id,
    String? uid,
    String? username,
    List? likes,
    int? commentCount,
    int? shareCount,
    String? caption,
    String? videoUrl,
    String? thumnail,
    String? profilePhoto,
  }) {
    return VideoModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      thumnail: thumnail ?? this.thumnail,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'likes': likes});
    result.addAll({'commentCount': commentCount});
    result.addAll({'shareCount': shareCount});
    result.addAll({'caption': caption});
    result.addAll({'videoUrl': videoUrl});
    result.addAll({'thumnail': thumnail});
    result.addAll({'profilePhoto': profilePhoto});

    return result;
  }

  factory VideoModel.fromSnap(DocumentSnapshot snap) {
    var map = snap.data() as Map<String, dynamic>;
    return VideoModel(
      id: map['id'] ,
      uid: map['uid'] ,
      username: map['username'] ,
      likes: List.from(map['likes']),
      commentCount: map['commentCount']?.toInt(),
      shareCount: map['shareCount']?.toInt(),
      caption: map['caption'] ,
      videoUrl: map['videoUrl'] ,
      thumnail: map['thumnail'] ,
      profilePhoto: map['profilePhoto'] ,
    );
  }

  @override
  String toString() {
    return 'VideoModel(id: $id, uid: $uid, username: $username, likes: $likes, commentCount: $commentCount, shareCount: $shareCount, caption: $caption, videoUrl: $videoUrl, thumnail: $thumnail, profilePhoto: $profilePhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoModel &&
        other.id == id &&
        other.uid == uid &&
        other.username == username &&
        listEquals(other.likes, likes) &&
        other.commentCount == commentCount &&
        other.shareCount == shareCount &&
        other.caption == caption &&
        other.videoUrl == videoUrl &&
        other.thumnail == thumnail &&
        other.profilePhoto == profilePhoto;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        username.hashCode ^
        likes.hashCode ^
        commentCount.hashCode ^
        shareCount.hashCode ^
        caption.hashCode ^
        videoUrl.hashCode ^
        thumnail.hashCode ^
        profilePhoto.hashCode;
  }
}
