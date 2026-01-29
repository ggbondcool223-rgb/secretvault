import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/index.dart';

class SvPrivacyAlbumLogic extends GetxController {
  final albums = <Album>[].obs;
  final isLoading = true.obs;

  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    loadAlbums();
  }


  Future<void> loadAlbums() async {
    try {
      isLoading.value = true;


      final albumList = await _db.getAlbums();


      if (albumList.isEmpty) {
        await _createDefaultAlbum();
        final updatedList = await _db.getAlbums();
        albums.value = updatedList;
      } else {

        for (var album in albumList) {
          final count = await _db.getMediaCountByAlbumId(album.id!);
          if (count != album.itemCount) {
            await _db.updateAlbumItemCount(album.id!, count);
          }
        }


        final updatedList = await _db.getAlbums();
        albums.value = updatedList;
      }
    } catch (e) {
      errorToast('Failed to load albums');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createDefaultAlbum() async {
    try {
      final defaultAlbum = Album(
        name: 'Default Album',
        itemCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _db.insertAlbum(defaultAlbum);
    } catch (e) {
      debugPrint('Error creating default album: $e');
    }
  }


  Future<void> createAlbum(String name) async {
    if (name.trim().isEmpty) {
      errorToast('Album name cannot be empty');
      return;
    }

    if (name.length > 20) {
      errorToast('Album name is too long (max 20 characters)');
      return;
    }


    final duplicate = albums.any((album) => album.name == name.trim());
    if (duplicate) {
      errorToast('Album name already exists');
      return;
    }

    try {
      final newAlbum = Album(
        name: name.trim(),
        itemCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _db.insertAlbum(newAlbum);
      await loadAlbums();
      Get.back();
    } catch (e) {
      errorToast('Failed to create album');
    }
  }


  Future<void> renameAlbum(Album album, String newName) async {
    if (newName.trim().isEmpty) {
      errorToast('Album name cannot be empty');
      return;
    }

    if (newName.length > 20) {
      errorToast('Album name is too long (max 20 characters)');
      return;
    }


    final duplicate = albums.any(
      (a) => a.id != album.id && a.name == newName.trim(),
    );
    if (duplicate) {
      errorToast('Album name already exists');
      return;
    }

    try {
      final updatedAlbum = Album(
        id: album.id,
        name: newName.trim(),
        itemCount: album.itemCount,
        createdAt: album.createdAt,
      );

      await _db.updateAlbum(updatedAlbum);
      await loadAlbums();
      successToast('Album renamed');
      Get.back();
    } catch (e) {
      errorToast('Failed to rename album');
    }
  }


  Future<void> deleteAlbum(Album album) async {

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Delete Album',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        content: Text(
          'Are you sure you want to delete "${album.name}"? All photos and videos in this album will be deleted. This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF7F8C8D)),
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

      await _db.deleteMediaByAlbumId(album.id!);


      await _db.deleteAlbum(album.id!);

      await loadAlbums();
      successToast('Album deleted');
    } catch (e) {
      errorToast('Failed to delete album');
    }
  }


  void showAlbumMenu(Album album) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF34495E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFFF39C12)),
              title: const Text(
                'Rename',
                style: TextStyle(color: Color(0xFFECF0F1)),
              ),
              onTap: () {
                Get.back();
                _showRenameDialog(album);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFFE74C3C)),
              title: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFECF0F1)),
              ),
              onTap: () {
                Get.back();
                deleteAlbum(album);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Color(0xFF7F8C8D)),
              title: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF7F8C8D)),
              ),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(Album album) {
    final controller = TextEditingController(text: album.name);

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Rename Album',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          style: const TextStyle(color: Color(0xFFECF0F1)),
          decoration: const InputDecoration(
            hintText: 'Album name...',
            hintStyle: TextStyle(color: Color(0xFF7F8C8D)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF7F8C8D)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF39C12)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7F8C8D)),
            ),
          ),
          TextButton(
            onPressed: () {
              renameAlbum(album, controller.text);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFFF39C12)),
            ),
          ),
        ],
      ),
    );
  }


  void onAlbumTap(Album album) async {
    await Get.toNamed(
      '/privacy/album/detail',
      arguments: {'albumId': album.id},
    );
    await loadAlbums();
  }
}
