import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'sv_privacy_album_logic.dart';

class SvPrivacyAlbumView extends GetView<SvPrivacyAlbumLogic> {
  const SvPrivacyAlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Private Album')),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(children: [Expanded(child: _buildAlbumList())]),
            _buildFAB(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFF39C12)),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
        ),
        itemCount: controller.albums.length,
        itemBuilder: (context, index) {
          return _buildAlbumCard(controller.albums[index]);
        },
      );
    });
  }

  Widget _buildAlbumCard(Album album) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2E33),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onAlbumTap(album),
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667eea),
                        const Color(0xFF764ba2).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.photo_library_rounded,
                          size: 42.sp,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${album.itemCount}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 6.h),
                      Text(
                        album.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${album.itemCount} items',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF7F8C8D),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.showAlbumMenu(album),
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              child: Icon(
                                Icons.more_vert_rounded,
                                size: 18.sp,
                                color: const Color(0xFFF39C12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: 24.h,
      right: 24.w,
      child: FloatingActionButton(
        onPressed: () => _showCreateAlbumDialog(),
        backgroundColor: const Color(0xFFF39C12),
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add_rounded, size: 32.sp, color: Colors.white),
      ),
    );
  }

  void _showCreateAlbumDialog() {
    final textController = TextEditingController();

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
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 16.w),
                  child: Text(
                    'Create New Album',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    maxLength: 20,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Album name...',
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF7F8C8D),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF17181A),
                      counterStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDialogButton(
                          label: 'Cancel',
                          color: const Color(0xFF3D4046),
                          textColor: const Color(0xFF7F8C8D),
                          onTap: () => Get.back(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildDialogButton(
                          label: 'Save',
                          color: const Color(0xFFF39C12),
                          textColor: Colors.white,
                          onTap: () =>
                              controller.createAlbum(textController.text),
                        ),
                      ),
                    ],
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

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
