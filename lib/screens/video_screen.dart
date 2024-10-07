import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/controllers/comment_controller.dart';
import 'package:shorts_clone/models/video_model.dart';
import 'package:shorts_clone/screens/profile_screen.dart';
import 'package:shorts_clone/widgets/circle_animation.dart';
import 'package:shorts_clone/widgets/comment_resolver.dart';

import '../controllers/video_homepage_controller.dart';
import '../widgets/video_player_item.dart';

class VideoHomePage extends StatefulWidget {
  VideoHomePage({super.key});

  @override
  State<VideoHomePage> createState() => _VideoHomePageState();
}

class _VideoHomePageState extends State<VideoHomePage> {
  late VideoHomeController videoHomeController;

  late TextEditingController commentTextController;

  late CommentController commentController;
  @override
  void initState() {
    videoHomeController = Get.put(VideoHomeController());
    commentTextController = TextEditingController();
    commentController = Get.put<CommentController>(CommentController());
    super.initState();
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videoHomeController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          itemBuilder: (context, index) {
            VideoModel videoModel = videoHomeController.videoList[index];
            return Stack(
              children: [
                VideoPlayerHome(videoUl: videoModel.videoUrl),
                // Container(
                //   width: Get.width,
                //   height: Get.height,
                //   decoration: const BoxDecoration(
                //     gradient: videoPlayerGradient,
                //   ),
                // ),
                Column(
                  children: [
                    giveSpace(height: 100),
                    Expanded(
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, bottom: 4),
                          width: Get.width * 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "@${videoModel.username}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              giveSpace(height: 4),
                              Text(
                                videoModel.caption,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                              giveSpace(height: 5)
                            ],
                          ),
                        ),

                        // for the action icons...
                        Container(
                          margin:
                              EdgeInsets.only(top: Get.height * 0.3, right: 2),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfileFunc(
                                    profilePhoto: videoModel.profilePhoto,
                                    uid: videoModel.uid),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          // like the video..
                                          videoHomeController.likeVideo(
                                              videoId: videoModel.id);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: !videoModel.likes.contains(
                                                  firebaseAuth.currentUser!.uid)
                                              ? Colors.white
                                              : Colors.red,
                                        )),
                                    giveSpace(height: 2),
                                    Text(videoModel.likes.length.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                                giveSpace(height: 16),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          // comment on the video..
                                          commentController
                                              .updatePostId(videoModel.id);
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              enableDrag: true,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(14),
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          14))),
                                              builder: (context) {
                                                return bottomBuilder();
                                              });
                                        },
                                        child: const Icon(Icons.comment,
                                            size: 30, color: Colors.white)),
                                    giveSpace(height: 2),
                                    Text(videoModel.commentCount.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white))
                                  ],
                                ),
                                giveSpace(height: 16),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          // share the video..
                                        },
                                        child: const Icon(Icons.share,
                                            size: 30, color: Colors.white)),
                                    giveSpace(height: 2),
                                    Text(videoModel.shareCount.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white))
                                  ],
                                ),
                                giveSpace(height: 16),
                                CircleAnimationWidget(
                                    child: buildMusicAlbum(
                                        videoModel.profilePhoto)),
                                giveSpace(height: 16)
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                )
              ],
            );
          });
    }));
  }

  buildProfileFunc({required String profilePhoto, required String uid}) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Positioned(
              left: 5,
              child: InkWell(
                onTap: () {
                  // navigate to user Profile...
                  Get.to(() => ProfileScreen(
                        uid: uid,
                        isFromSamePage: false,
                      ));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      gradient: shimmerGradient,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: bgColor, width: 1)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: NetworkImage(profilePhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: 8,
              right: 5,
              child: InkWell(
                onTap: () {
                  // make the user to follow...
                },
                child: const CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePic) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                gradient: musicGradient,
                borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePic),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomBuilder() {
    return Container(
      height: EdgeInsets.fromViewPadding(
                  WidgetsBinding.instance.window.viewInsets,
                  WidgetsBinding.instance.window.devicePixelRatio)
              .bottom +
          (Get.height / 2),
      width: Get.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      child: Column(
        children: [
          // for showingg the comment headline..
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              giveSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Comments',
                      style: Get.textTheme.bodyMedium!.copyWith(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const Divider(
                height: 1,
                color: Colors.black45,
              )
            ],
          ),

          // now the actaul comment will be polulated!
          Expanded(child: CommentResolver()),
          giveSpace(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width - 50,
                height: 40,
                child: TextField(
                  controller: commentTextController,
                  cursorColor: Colors.black54,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16),
                      hintText: 'Add a comment',
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              giveSpace(width: 8),
              InkWell(
                  onTap: () => commentController
                          .postComment(comment: commentTextController.text)
                          .then((value) => showMessenger(
                              message: 'Comment uploaded successfully!'))
                          .whenComplete(() {
                        commentController.isCommentUploading.toggle();
                        commentTextController.clear();
                      }).catchError((error) {
                        showMessenger(
                            message: error.toString(), titleCode: 'error');
                      }),
                  child: Obx(() => commentController.isCommentUploading.isTrue
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Icon(
                          Icons.telegram,
                          color: Colors.green,
                          size: 30,
                        )))
            ],
          ),
        ],
      ),
    );
  }
}
