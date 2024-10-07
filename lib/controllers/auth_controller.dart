import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/models/user_model.dart';
import 'package:shorts_clone/screens/auth_screen.dart';
import 'package:shorts_clone/screens/home_screen.dart';

enum AuthFragment { loginfragment, signUpFragment }

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final RxBool isLoading = RxBool(false);
  late Rx<User?> _user;
  Rx<AuthFragment> currentFragment = Rx(AuthFragment.loginfragment);
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    Future.delayed(const Duration(seconds: 3), () {
      _user.bindStream(firebaseAuth.authStateChanges());
      ever(_user, _setInitialScreen);
    });
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const AuthScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> createAccount(
      {required String email,
      required String username,
      required String password}) async {
    isLoading.toggle();
    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        UserCredential userCred = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel userModel = UserModel(
            name: username,
            profilePhoto:
                'https://res.cloudinary.com/djl7qs2sx/image/upload/v1691752995/man_ibdawi.png',
            email: email,
            bio: 'Hey there, i\'m using this app',
            uid: userCred.user!.uid);
        await firebaseFirestore
            .collection("users")
            .doc(userCred.user!.uid)
            .set(userModel.toJson());
        showMessenger(
            message: 'Account created successfully!, please login',
            titleCode: 'success');
      } else {
        showMessenger(
            titleCode: 'error', message: 'Please fill all the fields!');
      }
    } on FirebaseAuthException catch (e) {
      showMessenger(titleCode: 'error', message: e.message.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.toggle();
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        showMessenger(message: 'Logged in successfully!', titleCode: 'success');
        Get.offAll(() => const HomeScreen());
      } else {
        showMessenger(
            titleCode: 'error', message: 'Please fill all the fields!');
      }
    } on FirebaseAuthException catch (e) {
      showMessenger(titleCode: 'error', message: e.message.toString());
    }
  }

  Future<List<UserModel>> getUserList() async {
    List<UserModel> userList = [];
    try {
      final userDocs = await firebaseFirestore.collection('users').get();
      for (var user in userDocs.docs) {
        userList.add((UserModel.fromJson(user.data())));
      }
    } catch (error) {
      print(error);
      showMessenger(message: error.toString(), titleCode: 'error');
    }
    userList.removeWhere((element) => element.uid == user.uid);
    return userList;
  }
}
