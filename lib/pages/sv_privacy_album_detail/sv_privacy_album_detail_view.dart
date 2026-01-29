import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/components/image_viewer_page.dart';
import 'package:secret_vault/components/video_player_page.dart';
import 'sv_privacy_album_detail_logic.dart';

class SvPrivacyAlbumDetailView extends GetView<SvPrivacyAlbumDetailLogic> {
  const SvPrivacyAlbumDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(controller.albumName),
        actions: [
          IconButton(
            onPressed: () => _showFilterMenu(),
            icon: Icon(Icons.filter_list_rounded),
          ),
          IconButton(
            onPressed: controller.startSlideshow,
            icon: const Icon(Icons.play_circle_outline_rounded),
            tooltip: 'Slideshow',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(children: [Expanded(child: _buildPhotoGrid())]),
            _buildFAB(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFF39C12)),
        );
      }

      if (controller.mediaList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_rounded,
                size: 64.sp,
                color: const Color(0xFF34495E),
              ),
              SizedBox(height: 16.h),
              Text(
                'No media yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF7F8C8D),
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
        ),
        itemCount: controller.mediaList.length,
        itemBuilder: (context, index) {
          final media = controller.mediaList[index];
          return _buildPhotoItem(media);
        },
      );
    });
  }

  Widget _buildPhotoItem(Media media) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2E33),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _previewMedia(media),
          onLongPress: () => _showMediaMenu(media),
          borderRadius: BorderRadius.circular(8.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              fit: StackFit.expand,
              children: [

                _buildThumbnail(media),

                if (media.type == 'video')
                  Positioned(
                    bottom: 4.h,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(Media media) {
    final thumbnailFile = File(media.thumbnailPath);




    if (thumbnailFile.existsSync()) {
      try {
        final fileSize = thumbnailFile.lengthSync();


        if (fileSize == 0) {
          return _buildPlaceholderIcon(media.type);
        }

        return Image.file(
          thumbnailFile,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon(media.type);
          },
        );
      } catch (e) {
        return _buildPlaceholderIcon(media.type);
      }
    }

    return _buildPlaceholderIcon(media.type);
  }

  Widget _buildPlaceholderIcon(String type) {
    if (type == 'video') {

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.videocam_rounded,
            size: 48.sp,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      );
    }


    return Container(
      color: const Color(0xFF1A1C20),
      child: Center(
        child: Icon(
          Icons.photo_rounded,
          size: 32.sp,
          color: const Color(0xFF7F8C8D),
        ),
      ),
    );
  }

  void _previewMedia(Media media) async {
    if (media.type == 'image') {

      Get.to(
        () => ImageViewerPage(
          imagePath: media.thumbnailPath,
          title: media.originalName,
        ),
        transition: Transition.fadeIn,
      );
    } else if (media.type == 'video') {

      try {

        Get.dialog(
          const Center(
            child: CircularProgressIndicator(color: Color(0xFFF39C12)),
          ),
          barrierDismissible: false,
        );


        final decryptedBytes = await controller.decryptVideo(
          media.encryptedPath,
        );


        final tempDir = await controller.getTempDirectory();
        final tempVideoPath =
            '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final tempFile = File(tempVideoPath);
        await tempFile.writeAsBytes(decryptedBytes);


        Get.back();


        await Get.to(
          () => VideoPlayerPage(
            videoPath: tempVideoPath,
            title: media.originalName,
          ),
          transition: Transition.fadeIn,
        );


        try {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (e) {
          debugPrint('Error cleaning temp file: $e');
        }
      } catch (e) {
        Get.back();
        Get.snackbar(
          'Error',
          'Failed to load video: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showMediaMenu(Media media) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C2E33),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: const Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuOption(
              icon: Icons.delete_rounded,
              label: 'Delete',
              color: const Color(0xFFE74C3C),
              onTap: () {
                Get.back();
                controller.deleteMedia(media);
              },
            ),
            _buildMenuOption(
              icon: Icons.info_rounded,
              label: 'Info',
              color: Colors.white,
              onTap: () {
                Get.back();
                _showMediaInfo(media);
              },
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white10, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24.sp, color: color),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMediaInfo(Media media) {
    final fileSize = (media.fileSize / 1024 / 1024).toStringAsFixed(2);

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320.w,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2E33),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white10, width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Media Info',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoRow('Name', media.originalName),
                      SizedBox(height: 8.h),
                      _buildInfoRow('Type', media.type.toUpperCase()),
                      SizedBox(height: 8.h),
                      _buildInfoRow('Size', '$fileSize MB'),
                      SizedBox(height: 8.h),
                      _buildInfoRow('Created', media.createdAt.split(' ')[0]),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            '$label:',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7F8C8D)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: 24.h,
      right: 24.w,
      child: FloatingActionButton(
        onPressed: () {
          controller.importMedia();
        },
        backgroundColor: const Color(0xFFF39C12),
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add_rounded, size: 32.sp, color: Colors.white),
      ),
    );
  }

  void _showFilterMenu() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C2E33),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: const Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['All', 'Photos', 'Videos'].map((filter) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.changeFilter(filter);
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white10, width: 0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
    );
  }
}
