import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/controllers/add_video_controller.dart';
import 'package:shorts_clone/strings.dart';
import 'package:shorts_clone/widgets/custom_textfield.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class VideoConfirmScreen extends StatefulWidget {
  final String? mediumId;
  final String? videoFile;

  const VideoConfirmScreen({super.key, this.mediumId, this.videoFile});

  @override
  VideoConfirmScreenState createState() => VideoConfirmScreenState();
}

class VideoConfirmScreenState extends State<VideoConfirmScreen> {
  VideoPlayerController? _controller;
  File? _file;
  bool isMusicOn = true;
  late TextEditingController captionController;
  late AddVideoController videoController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    videoController = Get.find<AddVideoController>();
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    captionController.dispose();
    super.dispose();
  }

  Future<void> initAsync() async {
    try {
      _file = widget.mediumId == null
          ? File(widget.videoFile!)
          : await PhotoGallery.getFile(mediumId: widget.mediumId!);
      _controller = VideoPlayerController.file(_file!);
      _controller?.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {});
      });
    } catch (e) {
      showMessenger(message: 'Failed to Load Video');
    }
  }

  void soundToggle() {
    setState(() {
      isMusicOn == false
          ? _controller!.setVolume(0.0)
          : _controller!.setVolume(1.0);
      isMusicOn = !isMusicOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.70,
                width: Get.width,
                child: _controller == null || !_controller!.value.isInitialized
                    ? widget.mediumId == null
                        ? Shimmer(
                            gradient: shimmerGradient,
                            child: Container(
                              color: bgColor,
                            ))
                        : FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: MemoryImage(kTransparentImage),
                            image: ThumbnailProvider(
                              mediumId: widget.mediumId!,
                              mediumType: MediumType.video,
                              highQuality: true,
                            ),
                          )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                        onLongPress: soundToggle,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(
                            _controller!,
                          ),
                        ),
                      ),
              ),
              giveSpace(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Customtextfield(
                      controller: captionController,
                      hintText: 'Enter caption',
                      textInputAction: TextInputAction.done,
                    ),
                    giveSpace(height: 16),
                    Obx(() => SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_file == null ||
                                captionController.text.isEmpty) {
                              showMessenger(
                                  message: 'please check the credential',
                                  titleCode: 'error');
                            } else {
                              videoController.isVideoUploading.toggle();
                              videoController
                                  .uploadVideoPost(
                                      videoFile: _file!,
                                      caption: captionController.text)
                                  .whenComplete(() {
                                videoController.isVideoUploading.toggle();
                              });
                            }
                          },
                          child: videoController.isVideoUploading.isTrue
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ))
                              : const Text(
                                  Strings.uploadVideo,
                                ),
                        )))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
