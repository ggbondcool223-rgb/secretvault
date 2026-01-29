import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secret_vault/utils/encryption_helper.dart';
import 'sv_privacy_slideshow_logic.dart';

class SvPrivacySlideshowView extends StatelessWidget {
  const SvPrivacySlideshowView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SvPrivacySlideshowLogic>();


    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [

            Center(
              child: Obx(() {
                if (logic.currentMedia.value == null) {
                  return const CircularProgressIndicator(
                    color: Color(0xFFF39C12),
                  );
                }

                return PageView.builder(
                  controller: logic.pageController,
                  itemCount: logic.mediaList.length,
                  onPageChanged: logic.onPageChanged,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final media = logic.mediaList[index];
                    if (media.type == 'image') {
                      return FutureBuilder<Uint8List>(
                        future:
                            EncryptionHelper.decryptFile(media.encryptedPath),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return InteractiveViewer(
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.contain,
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF39C12),
                            ),
                          );
                        },
                      );
                    } else {

                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam_rounded,
                              size: 64,
                              color: Color(0xFF7F8C8D),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Video skipped',
                              style: TextStyle(
                                color: Color(0xFF7F8C8D),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              }),
            ),


            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Obx(() => Text(
                          '${logic.currentIndex.value + 1} / ${logic.mediaList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ),
            ),


            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: logic.previousImage,
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Obx(() => IconButton(
                              onPressed: logic.togglePlayPause,
                              icon: Icon(
                                logic.isPlaying.value
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_filled_rounded,
                                color: const Color(0xFFF39C12),
                                size: 56,
                              ),
                            )),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: logic.nextImage,
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),


                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Interval:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildIntervalButton(logic, 3),
                            const SizedBox(width: 8),
                            _buildIntervalButton(logic, 5),
                            const SizedBox(width: 8),
                            _buildIntervalButton(logic, 10),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalButton(SvPrivacySlideshowLogic logic, int seconds) {
    final isSelected = logic.interval.value == seconds;

    return GestureDetector(
      onTap: () => logic.changeInterval(seconds),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF39C12)
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${seconds}s',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
