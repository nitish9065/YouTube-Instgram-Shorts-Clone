import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/strings.dart';
import 'package:shorts_clone/widgets/custom_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController emailController;
  late TextEditingController userController;
  late TextEditingController passwordController;
  late AuthController authController;
  final Rx<bool> isObsecure = Rx(true);

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    emailController = TextEditingController();
    userController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              giveSpace(height: 32),
              Image.asset(
                "assets/images/tiktok.png",
                height: 150,
                width: 150,
              ),
              giveSpace(height: 16),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      border: Border.all(color: Colors.black12)),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        giveSpace(height: 10),
                        Obx(() => Visibility(
                              visible: authController.currentFragment.value ==
                                  AuthFragment.signUpFragment,
                              child: Customtextfield(
                                controller: userController,
                                hintText: 'Enter Username',
                                prefixicon: const Icon(
                                  Icons.emoji_emotions,
                                  color: Colors.black26,
                                ),
                              ),
                            )),
                        giveSpace(height: 10),
                        Customtextfield(
                          controller: emailController,
                          hintText: 'Enter Email',
                          prefixicon: const Icon(
                            Icons.email,
                            color: Colors.black26,
                          ),
                          textInputType: TextInputType.emailAddress,
                        ),
                        giveSpace(height: 10),
                        Obx(() => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Customtextfield(
                                  controller: passwordController,
                                  isObsecure: isObsecure.value,
                                  hintText: 'Enter Password',
                                  prefixicon: const Icon(
                                    Icons.lock,
                                    color: Colors.black26,
                                  ),
                                  suffixIcon: IconButton(
                                      padding: const EdgeInsets.all(2),
                                      onPressed: () {
                                        isObsecure.toggle();
                                      },
                                      icon: Icon(
                                        isObsecure.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black38,
                                      )),
                                  textInputAction: TextInputAction.done,
                                ),
                                giveSpace(height: 10),
                                InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      authController.currentFragment.value =
                                          authController
                                                      .currentFragment.value ==
                                                  AuthFragment.loginfragment
                                              ? AuthFragment.signUpFragment
                                              : AuthFragment.loginfragment;
                                    },
                                    child: Text(
                                      authController.currentFragment.value ==
                                              AuthFragment.loginfragment
                                          ? Strings.gotoSignUp
                                          : Strings.gotoLogin,
                                      style: const TextStyle(
                                          color: Colors.black38),
                                    )),
                                giveSpace(height: 10),
                                SizedBox(
                                    width: size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (authController
                                                .currentFragment.value ==
                                            AuthFragment.loginfragment) {
                                              await authController.signIn(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text).whenComplete(() => authController.isLoading.toggle());                                         
                                        } else {
                                            await authController
                                                .createAccount(
                                                    email: emailController.text,
                                                    username:
                                                        userController.text,
                                                    password:
                                                        passwordController.text).then((value) {
                                                          authController.currentFragment.value =
                                                AuthFragment.loginfragment;
                                                        })
                                                .whenComplete(() =>
                                                    authController.isLoading
                                                        .toggle());
                                        }
                                      },
                                      child: authController.isLoading.isTrue
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ))
                                          : Text(
                                              authController.currentFragment
                                                          .value ==
                                                      AuthFragment.loginfragment
                                                  ? Strings.signIn
                                                  : Strings.signUp,
                                                 
                                            ),
                                    ))
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
