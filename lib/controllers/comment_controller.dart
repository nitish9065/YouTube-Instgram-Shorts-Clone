import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';

import '../models/coment_model.dart';

class CommentController extends GetxController {
  final RxList<CommentModel> _comments = RxList.empty();
  List<CommentModel> get comments => _comments;
  final RxBool isCommentUploading = RxBool(false);

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(firebaseFirestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((event) {
      List<CommentModel> comments = [];
      for (var element in event.docs) {
        comments.add(CommentModel.fromSnap(element));
      }
      return comments;
    }));
  }

  Future<void> postComment({required String comment}) async {
    if (comment.isNotEmpty) {
      isCommentUploading.toggle();
      var userDoc = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      var allCommentsDocs = await firebaseFirestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .get();
      int len = allCommentsDocs.docs.length;
      CommentModel commentModel = CommentModel(
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          id: "comment $len",
          uid: (userDoc.data()! as dynamic)['uid'],
          username: (userDoc.data()! as dynamic)['name'],
          comment: comment,
          date: DateTime.now(),
          likes: []);
      await firebaseFirestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc('comment $len')
          .set(commentModel.toJson());
      var commentSnap =
          await firebaseFirestore.collection('videos').doc(_postId).get();
      await firebaseFirestore.collection('videos').doc(_postId).update({
        'commentCount': (commentSnap.data()! as dynamic)['commentCount'] + 1
      });
    } else {
      showMessenger(
          message: 'Can not upload empty comment!', titleCode: 'error');
    }
  }

  likeComment(String id) async {
    try {
      final uid = firebaseAuth.currentUser!.uid;
      var commentSnap = await firebaseFirestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .get();
      if ((commentSnap.data()! as dynamic)['likes'].contains(uid)) {
        await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      showMessenger(message: error.toString(), titleCode: 'error');
    }
  }
}
