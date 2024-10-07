import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/controllers/add_video_controller.dart';
import 'package:shorts_clone/widgets/shimmer_grid.dart';
import 'package:transparent_image/transparent_image.dart';

import 'video_confirm_screen.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  late AddVideoController addVideoController;
  @override
  void initState() {
    addVideoController = Get.put<AddVideoController>(AddVideoController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[500],
        title: const Text(
          "New Post",
        ),
        actions: [
          TextButton(
              onPressed: () => Get.to(() => VideoConfirmScreen(
                    mediumId: addVideoController.selectedVideo.value,
                  )),
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Obx(() => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              addVideoController.isLoading.isTrue ||
                      addVideoController.mediumList.isEmpty ||
                      addVideoController.selectedVideo.isEmpty
                  ? shimmerVideoGrid(length: 30)
                  : GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      children: <Widget>[
                        ...addVideoController.mediumList
                            .map((medium) => GestureDetector(
                                  onTap: () => {
                                    addVideoController.selectedVideo.value =
                                        medium.id
                                  },
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              MemoryImage(kTransparentImage),
                                          image: ThumbnailProvider(
                                            mediumId: medium.id,
                                            mediumType: medium.mediumType,
                                            highQuality: true,
                                          ),
                                        ),
                                        Obx(() => Positioned(
                                            top: 1,
                                            right: 1,
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Checkbox(
                                                side: const BorderSide(
                                                    color: bgColor),
                                                splashRadius: 15,
                                                value: addVideoController
                                                        .selectedVideo.value ==
                                                    medium.id,
                                                onChanged: (onChanged) {},
                                                shape: const CircleBorder(),
                                                fillColor:
                                                    const MaterialStatePropertyAll<
                                                            Color>(
                                                        Colors.deepPurple),
                                              ),
                                            )))
                                      ],
                                    ),
                                  ),
                                )),
                      ],
                    )
            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showOption(context: context),
        backgroundColor: const Color.fromARGB(255, 124, 45, 138),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  showOption({required BuildContext context}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () => pickVideo(source: ImageSource.gallery),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.purple.shade500,
                      ),
                      giveSpace(width: 16),
                      Text(
                        "Gallery",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: Colors.purple.shade500,
                        ),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => pickVideo(source: ImageSource.camera),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.purple.shade500,
                      ),
                      giveSpace(width: 16),
                      Text(
                        "Camera",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: Colors.purple.shade500,
                        ),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Get.back(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.purple.shade500,
                      ),
                      giveSpace(width: 16),
                      Text(
                        "Cancel",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: Colors.purple.shade500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ));
  }

  pickVideo({required ImageSource source}) async {
    final pickedVideo = await ImagePicker().pickVideo(source: source);
    if (pickedVideo != null) {
      Get.back();
      Get.to(() => VideoConfirmScreen(
            videoFile: pickedVideo.path,
          ));
    } else {
      Get.back();
      showMessenger(message: 'Video file not selected', titleCode: 'error');
    }
  }
}
