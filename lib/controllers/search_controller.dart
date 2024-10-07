import 'package:get/get.dart';
import 'package:shorts_clone/models/user_model.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';

class SearchScreenController extends GetxController {
  final RxList<UserModel> _users = RxList.empty();
  List<UserModel> get users => _users;
  RxList<UserModel> searchedUser = RxList.empty();

  getAllUsers()=>
    AuthController.instance.getUserList().then((users) => _users..clear()..addAll(users));
  
}
