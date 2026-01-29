import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/crypto_utils.dart';
import 'package:secret_vault/utils/index.dart';

class SvPrivacyNoteDetailLogic extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final isLoading = true.obs;
  final hasChanges = false.obs;

  int? _noteId;
  Timer? _autoSaveTimer;
  String _lastSavedContent = '';

  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    _setupAutoSave();
    _setupChangeListeners();
  }

  @override
  void onReady() {
    super.onReady();

    _initNote();
  }

  Future<void> _initNote() async {
    try {
      isLoading.value = true;


      final args = Get.arguments as Map<String, dynamic>?;
      _noteId = args?['noteId'] as int?;

      if (_noteId != null) {

        await _loadNote(_noteId!);
      } else {

        final useTemplate = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF34495E),
            title: const Text(
              'Use a Template?',
              style: TextStyle(color: Color(0xFFECF0F1)),
            ),
            content: const Text(
              'Would you like to start with a template?',
              style: TextStyle(color: Color(0xFFBDC3C7)),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Blank Note',
                  style: TextStyle(color: Color(0xFF7F8C8D)),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Choose Template',
                  style: TextStyle(color: Color(0xFFF39C12)),
                ),
              ),
            ],
          ),
        );

        if (useTemplate == true) {
          final templateData =
              await Get.toNamed('/privacy/note_template') as Map<String, dynamic>?;

          if (templateData != null) {
            titleController.text = templateData['title'] ?? '';
            contentController.text = templateData['content'] ?? '';
          }
        } else {
          titleController.text = '';
          contentController.text = '';
        }

        _lastSavedContent = '${titleController.text}|${contentController.text}';
      }
    } catch (e) {
      errorToast('Failed to load note');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadNote(int noteId) async {
    try {
      final note = await _db.getNoteById(noteId);
      if (note == null) {
        errorToast('Note not found');
        Get.back();
        return;
      }


      final password = await _db.getPassword();
      if (password == null) {
        errorToast('Password not set');
        Get.back();
        return;
      }

      final decryptedContent = CryptoUtils.decryptText(
        note.encryptedContent,
        password.encryptedPassword,
      );

      titleController.text = note.title;
      contentController.text = decryptedContent;
      _lastSavedContent = '${note.title}|$decryptedContent';
    } catch (e) {
      errorToast('Failed to load note');
    }
  }

  void _setupAutoSave() {

    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (hasChanges.value) {
        _autoSave();
      }
    });
  }

  void _setupChangeListeners() {
    titleController.addListener(_checkChanges);
    contentController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final currentContent = '${titleController.text}|${contentController.text}';
    hasChanges.value = currentContent != _lastSavedContent;
  }

  Future<void> _autoSave() async {
    if (!hasChanges.value) return;

    try {
      await _saveNote(showToast: false);
    } catch (e) {
      debugPrint('Error auto-saving note: $e');
    }
  }

  Future<void> onSaveTap() async {

    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {

      Get.back();
      return;
    }


    await _saveNote(showToast: false);


    Get.back();
  }

  Future<void> _saveNote({required bool showToast}) async {
    try {

      final password = await _db.getPassword();
      if (password == null) {
        errorToast('Password not set');
        return;
      }


      final encryptedContent = CryptoUtils.encryptText(
        contentController.text,
        password.encryptedPassword,
      );

      final title = titleController.text.trim().isEmpty
          ? 'Untitled Note'
          : titleController.text.trim();

      if (title.length > 50) {
        errorToast('Title is too long (max 50 characters)');
        return;
      }

      if (contentController.text.length > 10000) {
        errorToast('Content is too long (max 10000 characters)');
        return;
      }

      final now = DateTime.now().toIso8601String();

      if (_noteId == null) {

        final newNote = Note(
          title: title,
          encryptedContent: encryptedContent,
          createdAt: now,
          updatedAt: now,
        );

        _noteId = await _db.insertNote(newNote);
        _lastSavedContent = '${titleController.text}|${contentController.text}';
        hasChanges.value = false;

        if (showToast) {
          successToast('Note saved');
        }
      } else {

        final note = await _db.getNoteById(_noteId!);
        if (note == null) {
          errorToast('Note not found');
          return;
        }

        final updatedNote = Note(
          id: _noteId,
          title: title,
          encryptedContent: encryptedContent,
          createdAt: note.createdAt,
          updatedAt: now,
        );

        await _db.updateNote(updatedNote);
        _lastSavedContent = '${titleController.text}|${contentController.text}';
        hasChanges.value = false;

        if (showToast) {
          successToast('Note saved');
        }
      }
    } catch (e) {
      errorToast('Failed to save note');
    }
  }

  Future<bool> onWillPop() async {
    if (hasChanges.value) {

      await _saveNote(showToast: false);
    }
    return true;
  }

  @override
  void onClose() {
    _autoSaveTimer?.cancel();
    titleController.dispose();
    contentController.dispose();


    if (hasChanges.value) {
      _saveNote(showToast: false);
    }

    super.onClose();
  }
}
