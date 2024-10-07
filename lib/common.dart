import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

void showMessenger({required String message, String? titleCode}) {
  Color bgColor = const Color(0xFF303030);
  if (titleCode != null) {
    bgColor = titleCode.toLowerCase() == 'success' ? Colors.green : Colors.red;
  }
  Get.showSnackbar(GetSnackBar(
    message: message,
    backgroundColor: bgColor,
    duration: const Duration(seconds: 1),
  ));
}

giveSpace({double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Future<File?> imagePicker({required ImageSource source}) async {
  final pickedImage = await ImagePicker().pickImage(source: source);
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return null;
}

Future<String> uploadProfileToFireBase({required File image}) async {
  final ref =  firebaseStorage
      .ref()
      .child('ProfilePics')
      .child(firebaseAuth.currentUser!.uid);
  final uploadTask = ref.putFile(image);
  TaskSnapshot snap = await uploadTask;
  final url = await snap.ref.getDownloadURL();
  return url;
}

Future<String> getVideoThumnail(
    {required String videopath, required String videoId}) async {
  final ref = firebaseStorage.ref().child('VideoThubmails').child(videoId);
  final thumbnail = await VideoCompress.getFileThumbnail(videopath);
  final uploadTask = ref.putFile(thumbnail);
  TaskSnapshot snap = await uploadTask;
  final url = await snap.ref.getDownloadURL();
  return url;
}

Future<String> uploadVideoToFireStore(
    {required File video, required String videoId}) async {
  final ref = firebaseStorage.ref().child("Videos").child(videoId);
  //compressing the video..
  // final compressedVideo = await _compressVideo(videoPath: video.path);
  final uploadTask = ref.putFile(video);
  TaskSnapshot snap = await uploadTask;
  final url = await snap.ref.getDownloadURL();
  return url;
}

Future<File> _compressVideo({required String videoPath}) async {
  final MediaInfo? compressedVideo = await VideoCompress.compressVideo(videoPath,
      quality: VideoQuality.MediumQuality, deleteOrigin: false);
  if (compressedVideo == null || compressedVideo.file == null) {
    throw 'Error occured while compressing video';
  }
    return compressedVideo.file!;
}

Future<String> uploadVideoToCloudinary({required File file}) async {
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '966713744158859',
    apiSecret: '6Eb4S49Qv7oxnAVRAEExQKdyK5w',
    cloudName: 'dlzhqw7dz',
  );
    final compressedVideo = await _compressVideo(videoPath: file.path);

    final response = await cloudinary.upload(
        file: compressedVideo.path,
        fileBytes: compressedVideo.readAsBytesSync(),
        resourceType: CloudinaryResourceType.video,
        folder: 'Videos',
        fileName: file.path.split('/').last,
        progressCallback: (count, total) {});
        return response.secureUrl ?? '';
}

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
