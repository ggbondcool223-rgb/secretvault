import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/index.dart';
import 'package:secret_vault/pages/sv_privacy_slideshow/sv_privacy_slideshow_view.dart';
import 'package:secret_vault/pages/sv_privacy_slideshow/sv_privacy_slideshow_logic.dart';

class SvPrivacyAlbumDetailLogic extends GetxController {
  final mediaList = <Media>[].obs;
  final selectedFilter = 'All'.obs;
  final isLoading = true.obs;

  int? _albumId;
  Album? _album;

  final _db = Get.find<DatabaseService>();
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadAlbumDetail();
  }

  Future<void> _loadAlbumDetail() async {
    try {
      isLoading.value = true;

      final args = Get.arguments as Map<String, dynamic>?;
      _albumId = args?['albumId'] as int?;

      if (_albumId == null) {
        errorToast('Album not found');
        Get.back();
        return;
      }

      _album = await _db.getAlbumById(_albumId!);
      if (_album == null) {
        errorToast('Album not found');
        Get.back();
        return;
      }

      await loadMedia();
    } catch (e) {
      errorToast('Failed to load album');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMedia() async {
    if (_albumId == null) return;

    try {
      final type = selectedFilter.value == 'All'
          ? null
          : selectedFilter.value.toLowerCase();

      final media = await _db.getMediaByAlbumId(_albumId!, type: type);
      mediaList.value = media;
    } catch (e) {
      errorToast('Failed to load media');
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    loadMedia();
  }


  Future<void> importMedia() async {

    final mediaType = await Get.bottomSheet<String>(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C2E33),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: const Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaTypeOption(
              icon: Icons.photo_library_rounded,
              label: 'Import Photos',
              type: 'photos',
            ),
            _buildMediaTypeOption(
              icon: Icons.videocam_rounded,
              label: 'Import Videos',
              type: 'videos',
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
    );

    if (mediaType == null) return;

    try {
      List<XFile> pickedFiles = [];

      if (mediaType == 'photos') {

        pickedFiles = await _picker.pickMultiImage();
      } else if (mediaType == 'videos') {

        final video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          pickedFiles = [video];
        }
      }

      if (pickedFiles.isEmpty) {
        return;
      }


      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFFF39C12)),
        ),
        barrierDismissible: false,
      );

      int successCount = 0;
      int failedCount = 0;

      for (final file in pickedFiles) {
        try {

          final detectedType = MediaHelper.detectMediaType(file.path);
          if (detectedType == 'unknown') {
            failedCount++;
            continue;
          }


          final privateDir = await MediaHelper.getPrivateDirectory();
          final thumbnailDir = await MediaHelper.getThumbnailDirectory();


          final encryptedPath = await MediaHelper.encryptAndSaveFile(
            file,
            privateDir,
          );


          final thumbnailPath = await MediaHelper.generateThumbnail(
            file,
            detectedType,
            thumbnailDir,
          );


          final fileSize = await MediaHelper.getFileSize(file.path);
          final originalName = file.name;


          final media = Media(
            albumId: _albumId!,
            type: detectedType,
            encryptedPath: encryptedPath,
            thumbnailPath: thumbnailPath,
            originalName: originalName,
            fileSize: fileSize,
            createdAt: DateTime.now().toString(),
          );

          await _db.insertMedia(media);
          successCount++;



        } catch (e) {
          failedCount++;
        }
      }


      Get.back();


      if (_albumId != null) {
        final count = await _db.getMediaCountByAlbumId(_albumId!);
        await _db.updateAlbumItemCount(_albumId!, count);
      }


      await loadMedia();


      if (successCount > 0) {
        successToast(
          'Imported $successCount ${successCount == 1 ? 'item' : 'items'}',
        );
      }
      if (failedCount > 0) {
        errorToast(
          'Failed to import $failedCount ${failedCount == 1 ? 'item' : 'items'}',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      errorToast('Failed to import media');
    }
  }

  Widget _buildMediaTypeOption({
    required IconData icon,
    required String label,
    required String type,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.back(result: type),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white10, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: const Color(0xFFF39C12)),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> deleteMedia(Media media) async {
    if (media.id == null) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text('Delete', style: TextStyle(color: Color(0xFFECF0F1))),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(color: Color(0xFF7F8C8D)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7F8C8D)),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFE74C3C)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {

      await _db.deleteMedia(media.id!);


      await MediaHelper.deleteFile(media.encryptedPath);
      await MediaHelper.deleteFile(media.thumbnailPath);


      mediaList.remove(media);


      if (_albumId != null) {
        final count = await _db.getMediaCountByAlbumId(_albumId!);
        await _db.updateAlbumItemCount(_albumId!, count);
      }

      successToast('Deleted');
    } catch (e) {
      errorToast('Failed to delete');
    }
  }


  Future<Uint8List> decryptVideo(String encryptedPath) async {
    return await EncryptionHelper.decryptFile(encryptedPath);
  }


  Future<Directory> getTempDirectory() async {
    return await getTemporaryDirectory();
  }


  Future<void> startSlideshow() async {
    if (mediaList.isEmpty) {
      errorToast('No images to show');
      return;
    }


    final images = mediaList.where((m) => m.type == 'image').toList();

    if (images.isEmpty) {
      errorToast('No images to show');
      return;
    }

    Get.to(
      () => const SvPrivacySlideshowView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SvPrivacySlideshowLogic(
              mediaList: images,
              initialIndex: 0,
            ));
      }),
      transition: Transition.fadeIn,
    );
  }

  String get albumName => _album?.name ?? '';
}
