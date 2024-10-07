import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/models/video_model.dart';

class VideoHomeController extends GetxController {
  final RxList<VideoModel> _videoList = RxList.empty();
  List<VideoModel> get videoList => _videoList;
  final AuthController authController = Get.find<AuthController>();
  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firebaseFirestore.collection('videos').snapshots().map((event) {
      List<VideoModel> reval = [];
      for (var element in event.docs) {
        reval.add(VideoModel.fromSnap(element));
      }
      return reval;
    }));
  }

  likeVideo({required String videoId}) async {
    final videoDoc =
        await firebaseFirestore.collection('videos').doc(videoId).get();
    final uid = authController.user.uid;
    if ((videoDoc.data()!)['likes'].contains(uid)) {
      await firebaseFirestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  commentOnVideo({required String videoId}){
    
  }
}
