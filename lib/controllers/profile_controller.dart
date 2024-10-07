import 'dart:io';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/models/user_model.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool userSuggestionLoading = RxBool(false);
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  RxList<UserModel> suggestedUser = RxList.empty();
  Rx<File?> imageProfile = Rx(null);

  String _userId = '';
  updateUserId(String id) {
    _userId = id;
    getUserData().then((value) => isLoading.toggle());
  }

  String get userId => _userId;

  void clearSuggesteduser() {
    suggestedUser.clear();
  }

  Future<void> getUserData() async {
    isLoading.toggle();
    List<String> thumbnails = [];
    var snapVideos = await firebaseFirestore
        .collection('videos')
        .where('uid', isEqualTo: _userId)
        .get();
    for (int i = 0; i < snapVideos.docs.length; i++) {
      thumbnails.add((snapVideos.docs[i].data() as dynamic)['thumnail']);
    }

    final userDoc =
        await firebaseFirestore.collection('users').doc(_userId).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String bio = userData['bio'];
    String profilePhoto = userData['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;
    for (var videoItem in snapVideos.docs) {
      likes += (videoItem.data()['likes'] as List).length;
    }
    var followerDoc = await firebaseFirestore
        .collection('users')
        .doc(_userId)
        .collection('followers')
        .get();

    var followingDoc = await firebaseFirestore
        .collection('users')
        .doc(_userId)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;
    firebaseFirestore
        .collection('users')
        .doc(_userId)
        .collection('followers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'bio': bio,
      'thumbnails': thumbnails
    };
    update();
  }

  getUserSuggestion() {
    userSuggestionLoading.toggle();
    AuthController.instance
        .getUserList()
        .then((value) => suggestedUser
          ..clear()
          ..addAll(value))
        .whenComplete(() {
      userSuggestionLoading.toggle();
    });
  }

  logout() async {
    isLoading.toggle();
    Future.delayed(const Duration(seconds: 2), () async {
      await firebaseAuth.signOut().whenComplete(() {
        isLoading.toggle();
      });
    });
  }

  followUser() async {
    var doc = await firebaseFirestore
        .collection('users')
        .doc(_userId)
        .collection('followers')
        .doc(AuthController.instance.user.uid)
        .get();
    if (!doc.exists) {
      await firebaseFirestore
          .collection('users')
          .doc(_userId)
          .collection('followers')
          .doc(AuthController.instance.user.uid)
          .set({});
      //updating the current user's account following section
      await firebaseFirestore
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_userId)
          .set({});
      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(_userId)
          .collection('followers')
          .doc(AuthController.instance.user.uid)
          .delete();
      //updating the current user's account following section
      await firebaseFirestore
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_userId)
          .delete();
      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }

  Future<void> updateProfile(
      {File? imageFile, required String username, required String bio}) async {
    String profileUrl = _user.value['profilePhoto'];
    if (imageFile != null) {
      profileUrl = await uploadProfileToFireBase(image: imageFile);
    }
    firebaseFirestore
        .collection('users')
        .doc(AuthController.instance.user.uid)
        .set({'profilePhoto': profileUrl, 'name': username, 'bio': bio}).then(
            (value) {
      Get.back();
      _user.value.update('profilePhoto', (value) => profileUrl);
      _user.value.update('name', (value) => username);
      _user.value.update('bio', (value) => bio);
      update();
      showMessenger(
          message: 'Profile updated successfully', titleCode: 'success');
    }).catchError((error) {
      Get.back();
      imageProfile.value = null;
      showMessenger(message: 'Error occured while updating profile');
    });
  }
}
