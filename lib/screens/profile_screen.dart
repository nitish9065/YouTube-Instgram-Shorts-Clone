import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/controllers/profile_controller.dart';
import 'package:shorts_clone/models/user_model.dart';
import 'package:shorts_clone/screens/add_video.dart';
import 'package:shorts_clone/screens/message_screen.dart';
import 'package:shorts_clone/widgets/custom_textfield.dart';
import 'package:shorts_clone/widgets/profile_screen_shimmer.dart';
import 'package:shorts_clone/widgets/transparent_button.dart';
import 'package:shorts_clone/widgets/user_suggestion_card.dart';
import 'package:shorts_clone/widgets/user_suggestion_shimmer_card.dart';
import 'package:transparent_image/transparent_image.dart';
import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.uid, this.isFromSamePage = true});
  final String uid;
  final bool? isFromSamePage;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;
  late AuthController authController;
  late TextEditingController userNameController;
  late TextEditingController bioController;
  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    controller.updateUserId(widget.uid);
    controller.clearSuggesteduser();
    authController = Get.find<AuthController>();
    userNameController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (cont) {
          if (controller.isLoading.isTrue) {
            return const ProfileScreenShimmer();
          } else {
            return Scaffold(
              appBar: AppBar(
                leadingWidth: 30,
                leading: (authController.user.uid != controller.userId &&
                        widget.isFromSamePage!)
                    ? IconButton(
                        onPressed: () {
                          controller.updateUserId(widget.uid);
                          controller.clearSuggesteduser();
                          // setState(() {});
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ))
                    : null,
                backgroundColor: Colors.purple[500],
                title: GestureDetector(
                  onTap: () => authController.user.uid == controller.userId
                      ? showModelBar(child: authModel())
                      : null,
                  child: Row(
                    children: [
                      Text(
                        controller.user['name'],
                      ),
                      giveSpace(width: 4),
                      Visibility(
                        visible: authController.user.uid == controller.userId,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  Visibility(
                    visible: authController.user.uid == controller.userId,
                    child: IconButton(
                        onPressed: () {
                          Get.to(() => const AddVideo());
                        },
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      giveSpace(height: 16),
                      //main profile pic and followers, following, and post count...
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(0),
                              decoration: const BoxDecoration(
                                gradient: shimmerGradient,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image(
                                  image: NetworkImage(
                                      controller.user['profilePhoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  userSection(
                                      number: controller
                                          .user['thumbnails'].length
                                          .toString(),
                                      text: "Posts"),
                                  userSection(
                                      number: controller.user['followers'],
                                      text: "Followers"),
                                  userSection(
                                      number: controller.user['following'],
                                      text: "Following"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      giveSpace(height: 8),
                      //username and the bio of the user...
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user['name'],
                                style: Get.textTheme.bodyMedium!.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                              giveSpace(height: 2),
                              Text(
                                controller.user['bio'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.bodyMedium!
                                    .copyWith(color: Colors.black54),
                              ),
                            ]),
                      ),
                      giveSpace(height: 8),
                      // edit profile and the signout or follow button....
                      userActionButtons(
                          isFollowing: controller.user['isFollowing']),
                      const Divider(),
                      Obx(() {
                        return controller.suggestedUser.isNotEmpty &&
                                controller.userSuggestionLoading.isFalse
                            ? Container(
                                height: 210,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: controller.suggestedUser.length,
                                    itemBuilder: (context, index) {
                                      UserModel user =
                                          controller.suggestedUser[index];
                                      return SizedBox(
                                        width: Get.width / 2,
                                        child: userSuggestionCard(
                                            user: user,
                                            buttonText: 'See Profile',
                                            onTap: () {
                                              controller.updateUserId(user.uid);
                                              controller.clearSuggesteduser();
                                              setState(() {});
                                            }),
                                      );
                                    }),
                              )
                            : controller.userSuggestionLoading.isTrue &&
                                    controller.suggestedUser.isEmpty
                                ? Container(
                                    height: 210,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            width: Get.width / 2,
                                            child: userSuggestionShimmerCard(),
                                          );
                                        }),
                                  )
                                : const SizedBox.shrink();
                      }),
                      const Divider(),
                      // now the post of the users will be displayed...
                      if (controller.user['thumbnails'].isNotEmpty)
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          children: <Widget>[
                            ...controller.user['thumbnails']
                                .map((thumbnail) => GestureDetector(
                                      onTap: () => {
                                        // navigate to video page...
                                      },
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              MemoryImage(kTransparentImage),
                                          image: NetworkImage(thumbnail),
                                        ),
                                      ),
                                    )),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget userActionButtons({required bool isFollowing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: transparentButton(
                buttonText: authController.user.uid == controller.userId
                    ? 'Edit profile'
                    : !isFollowing
                        ? 'Unfollow'
                        : 'Follow',
                onTap: () {
                  //edit the profile or do the implication of follow and unfollow...
                  if (authController.user.uid == controller.userId) {
                    //edit the profile..
                    controller.imageProfile.value = null;
                    userNameController.text = controller.user['name'];
                    bioController.text = controller.user['bio'];
                    showModelBar(
                        isDrag: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            giveSpace(height: 16),
                            Stack(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: shimmerGradient,
                                      color: Colors.black),
                                  child: Obx(() =>
                                     ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: controller.imageProfile.value == null
                                          ? Image.network(
                                              controller.user['profilePhoto'],
                                              fit: BoxFit.cover,
                                            )
                                          :  Image.file(
                                                controller.imageProfile.value!,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 3,
                                    child: InkWell(
                                        onTap: () async {
                                          final imageFile = await imagePicker(
                                              source: ImageSource.gallery);
                                          if (imageFile != null) {
                                            controller.imageProfile.value =
                                                imageFile;
                                          } else {
                                            showMessenger(
                                                message: 'Image not selected',
                                                titleCode: 'error');
                                          }
                                        },
                                        child: const CircleAvatar(
                                          radius: 10,
                                          child: Icon(
                                            Icons.add,
                                            size: 16,
                                          ),
                                        )))
                              ],
                            ),
                            giveSpace(height: 16),
                            Customtextfield(
                              controller: userNameController,
                              hintText: 'username',
                            ),
                            giveSpace(height: 8),
                            Customtextfield(
                              controller: bioController,
                              hintText: 'bio',
                            ),
                            giveSpace(height: 8),
                            SizedBox(
                                width: Get.width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    controller.isLoading.toggle();
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      controller
                                          .updateProfile(
                                              imageFile:
                                                  controller.imageProfile.value,
                                              username: userNameController.text,
                                              bio: bioController.text)
                                          .whenComplete(() {
                                        controller.isLoading.toggle();
                                      });
                                    });
                                  },
                                  child: Obx(() => controller.isLoading.isTrue
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ))
                                      : const Text('Update Profile')),
                                )),
                            giveSpace(height: 8)
                          ],
                        ));
                  } else {
                    controller.followUser();
                  }
                }),
          ),
          giveSpace(width: 8),
          Expanded(
            child: transparentButton(
                buttonText: authController.user.uid == controller.userId
                    ? 'Signout'
                    : 'Message',
                onTap: () {
                  //signout from the profile or send to message the user..
                  authController.user.uid == controller.userId
                      ? showModelBar(child: authModel())
                      : Get.to(() => const MessageScreen());
                }),
          ),
          giveSpace(width: 8),
          transparentButton(
              isIcon: true,
              iconData: Icons.group_add,
              onTap: () {
                //show the suggestions
                controller.suggestedUser.isNotEmpty
                    ? controller.clearSuggesteduser()
                    : controller.getUserSuggestion();
              }),
        ],
      ),
    );
  }

  Column userSection({required String number, required String text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: Get.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        giveSpace(height: 4),
        Text(
          text,
          style: Get.textTheme.bodyMedium!.copyWith(color: Colors.black),
        )
      ],
    );
  }

  showModelBar({required Widget child, bool? isDrag = false}) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: isDrag!,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          builder: (context) {
            return Padding(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 16,
              // ).copyWith(
              //   bottom: 8,
              // ),
              padding: MediaQuery.of(context).viewInsets.copyWith(
                    right: 16,
                    left: 16,
                  ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    giveSpace(height: 8),
                    Container(
                      alignment: Alignment.center,
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black45),
                    ),
                    child
                  ],
                ),
              ),
            );
          });
  Widget authModel() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(4),
            horizontalTitleGap: 8,
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.purple[500],
            ),
            title: Text(
              "Logout",
              style: Get.textTheme.bodyMedium!.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
            onTap: () => controller.logout(),
            trailing: Obx(() => controller.isLoading.isTrue
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                      strokeWidth: 2.5,
                    ))
                : const SizedBox.shrink()),
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(4),
            horizontalTitleGap: 8,
            leading: Icon(
              Icons.close,
              color: Colors.purple[500],
            ),
            title: Text(
              "Cancel",
              style: Get.textTheme.bodyMedium!.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
            onTap: () => Get.back(),
          ),
        ],
      );
}
