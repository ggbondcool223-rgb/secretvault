import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';

class SvPrivacySlideshowLogic extends GetxController {
  final List<Media> mediaList;
  final int initialIndex;

  SvPrivacySlideshowLogic({
    required this.mediaList,
    this.initialIndex = 0,
  });

  late final PageController pageController;
  final currentIndex = 0.obs;
  final currentMedia = Rx<Media?>(null);
  final isPlaying = true.obs;
  final interval = 5.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: initialIndex);
    currentIndex.value = initialIndex;
    currentMedia.value = mediaList[initialIndex];
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: interval.value), (timer) {
      if (isPlaying.value) {
        nextImage();
      }
    });
  }

  void nextImage() {
    if (currentIndex.value < mediaList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {

      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousImage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {

      pageController.animateToPage(
        mediaList.length - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    currentMedia.value = mediaList[index];
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
  }

  void changeInterval(int seconds) {
    interval.value = seconds;
    _startAutoPlay();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
