import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shorts_clone/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerHome extends StatefulWidget {
  const VideoPlayerHome({super.key, required this.videoUl});
  final String videoUl;

  @override
  State<VideoPlayerHome> createState() => _VideoPlayerHomeState();
}

class _VideoPlayerHomeState extends State<VideoPlayerHome> {
  late VideoPlayerController videoPlayerController;
  bool isMusicOn = true;
  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUl))
          ..initialize().then((value) {
            videoPlayerController.play();
            videoPlayerController.setVolume(1);
            videoPlayerController.setLooping(true);
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void configureVolume() {
    setState(() {
      isMusicOn
          ? videoPlayerController.setVolume(0)
          : videoPlayerController.setVolume(1);
      showSoundIcon(context: context);
      isMusicOn = !isMusicOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: configureVolume,
      child: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: videoPlayerGradient,
        ),
        child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(
                  videoPlayerController,
                )),
      ),
    );
  }
/**
   !videoPlayerController.value.isInitialized
            ? Shimmer(
                gradient: shimmerGradient,
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.black,
                ))
            :
 */
  void showSoundIcon({
    required BuildContext context,
  }) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
        builder: (context) => !isMusicOn
            ? const Icon(
                Icons.volume_off,
                size: 40,
                color: Colors.white,
              )
            : const Icon(
                Icons.volume_up,
                size: 40,
                color: Colors.white,
              ));
    Overlay.of(context).insert(overlayEntry);
    Timer(const Duration(seconds: 1), () => overlayEntry.remove());
  }
}
