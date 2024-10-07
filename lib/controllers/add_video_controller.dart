import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/models/video_model.dart';

import '../screens/home_screen.dart';

class AddVideoController extends GetxController {
  RxSet<Medium> mediumList = RxSet({});
  RxBool isLoading = true.obs;
  RxString selectedVideo = RxString('');
  RxBool isVideoUploading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getAlbumList();
    mediumList.listen((mediumSet) {
      if (mediumSet.isNotEmpty) {
        selectedVideo.value = mediumList.first.id;
      }
    });
  }

  Future<void> getAlbumList() async {
    if (await checkPermission()) {
      mediumList.clear();
      PhotoGallery.listAlbums(mediumType: MediumType.video)
          .then((albumList) async {
        for (var album in albumList) {
          album.listMedia().then((mediaPage) {
            mediumList.addAll(mediaPage.items);
          });
        }
      }).whenComplete(() {
        isLoading.toggle();
      });
    }
  }

   Future<bool> checkPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 30) {
      return (await Permission.manageExternalStorage.isGranted ||
          await Permission.manageExternalStorage.request().isGranted);
    } else {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  Future<void> uploadVideoPost(
      {required File videoFile, required String caption}) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      // get the video id.
      var allDocs = await firebaseFirestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl =
          await uploadVideoToFireStore(video: videoFile, videoId: "video $len");
      String thubmailUrl = await getVideoThumnail(
          videopath: videoFile.path, videoId: "video $len");
      VideoModel videoModel = VideoModel(
          id: "video $len",
          uid: uid,
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          likes: [],
          commentCount: 0,
          shareCount: 0,
          caption: caption,
          videoUrl: videoUrl,
          thumnail: thubmailUrl,
          profilePhoto:
              (userDoc.data() as Map<String, dynamic>)['profilePhoto']);
      await firebaseFirestore
          .collection('videos')
          .doc('video $len')
          .set(videoModel.toJson())
          .then((value) {
        showMessenger(
            message: 'Video uploaded successfully!', titleCode: 'success');
        Get.offAll(const HomeScreen());
      });
    } catch (e) {
      showMessenger(message: e.toString(), titleCode: 'error');
    }
  }
}
