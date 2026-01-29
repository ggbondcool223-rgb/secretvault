import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/index.dart';

class SvPrivacyNotesLogic extends GetxController {
  final notes = <Note>[].obs;
  final isLoading = true.obs;

  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }


  Future<void> loadNotes() async {
    try {
      isLoading.value = true;
      final noteList = await _db.getNotes();
      notes.value = noteList;
    } catch (e) {
      errorToast('Failed to load notes');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createNote() async {
    await Get.toNamed('/privacy/notes/detail');
    await loadNotes();
  }


  Future<void> deleteNote(Note note) async {
    if (note.id == null) return;


    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        content: Text(
          'Are you sure you want to delete "${note.title}"? This action cannot be undone.',
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
      await _db.deleteNote(note.id!);
      notes.remove(note);
      successToast('Note deleted');
    } catch (e) {
      errorToast('Failed to delete note');
    }
  }


  void showNoteMenu(Note note) {
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
              leading: const Icon(Icons.delete, color: Color(0xFFE74C3C)),
              title: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFECF0F1)),
              ),
              onTap: () {
                Get.back();
                deleteNote(note);
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


  void onNoteTap(Note note) {
    Get.toNamed('/privacy/notes/detail', arguments: {'noteId': note.id});
  }


  String formatTime(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDateTime;
    }
  }
}
