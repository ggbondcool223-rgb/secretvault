import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/crypto_utils.dart';
import 'package:secret_vault/utils/index.dart';

class SvSettingsResetPasswordLogic extends GetxController {
  final currentStep = 1.obs;
  final password = ''.obs;
  final passwordDots = <bool>[].obs;

  String _oldPassword = '';
  String _newPassword = '';
  bool _skipOldPassword = false;

  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();


    final args = Get.arguments as Map<String, dynamic>?;
    _skipOldPassword = args?['skipOldPassword'] as bool? ?? false;

    if (_skipOldPassword) {

      currentStep.value = 2;
    }
  }

  String get stepTitle {
    switch (currentStep.value) {
      case 1:
        return 'Step 1/3: Enter old password';
      case 2:
        return 'Step 2/3: Set new password';
      case 3:
        return 'Step 3/3: Confirm new password';
      default:
        return '';
    }
  }

  String get stepDescription {
    switch (currentStep.value) {
      case 1:
        return 'Please enter your old password';
      case 2:
        return 'Please set new password';
      case 3:
        return 'Please confirm your new password';
      default:
        return '';
    }
  }

  void addNumber(String number) {
    if (password.value.length < 6) {
      password.value += number;
      passwordDots.add(true);


      if (password.value.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _handlePasswordComplete();
        });
      }
    }
  }

  void deleteNumber() {
    if (password.value.isNotEmpty) {
      password.value = password.value.substring(0, password.value.length - 1);
      passwordDots.removeLast();
    }
  }

  void clear() {
    password.value = '';
    passwordDots.clear();
  }

  Future<void> _handlePasswordComplete() async {
    switch (currentStep.value) {
      case 1:
        if (_skipOldPassword) {
          _oldPassword = '';
          currentStep.value = 2;
          clear();
        } else {
          await _verifyOldPassword();
        }
        break;
      case 2:
        _newPassword = password.value;
        currentStep.value = 3;
        clear();
        break;
      case 3:
        await _confirmAndSaveNewPassword();
        break;
    }
  }

  Future<void> _verifyOldPassword() async {
    try {
      final existingPassword = await _db.getPassword();
      if (existingPassword == null) {
        errorToast('Password not set');
        Get.back();
        return;
      }

      if (CryptoUtils.verifyPassword(
        password.value,
        existingPassword.encryptedPassword,
      )) {

        _oldPassword = password.value;
        currentStep.value = 2;
        clear();
      } else {

        errorToast('Wrong password');
        HapticFeedback.vibrate();
        clear();
      }
    } catch (e) {
      errorToast('Verification failed');
      clear();
    }
  }

  Future<void> _confirmAndSaveNewPassword() async {
    if (_newPassword != password.value) {
      errorToast('Passwords do not match');
      HapticFeedback.vibrate();
      currentStep.value = 2;
      clear();
      return;
    }

    if (_newPassword == _oldPassword) {
      errorToast('New password is same as old password');
      currentStep.value = 2;
      clear();
      return;
    }

    try {

      final existingPassword = await _db.getPassword();
      if (existingPassword == null) {
        errorToast('Password not found');
        Get.back();
        return;
      }

      final encryptedPassword = CryptoUtils.hashPassword(_newPassword);
      final updatedPassword = Password(
        id: existingPassword.id,
        encryptedPassword: encryptedPassword,
        createdAt: existingPassword.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _db.updatePassword(updatedPassword);


      await _reEncryptNotes(_oldPassword, _newPassword);

      Get.back();
    } catch (e) {
      errorToast('Failed to reset password');
      clear();
    }
  }

  Future<void> _reEncryptNotes(String oldPassword, String newPassword) async {
    try {

      final notes = await _db.getNotes();

      final oldPasswordHash = CryptoUtils.hashPassword(oldPassword);
      final newPasswordHash = CryptoUtils.hashPassword(newPassword);

      for (var note in notes) {

        final decryptedContent = CryptoUtils.decryptText(
          note.encryptedContent,
          oldPasswordHash,
        );


        final reEncryptedContent = CryptoUtils.encryptText(
          decryptedContent,
          newPasswordHash,
        );


        final updatedNote = Note(
          id: note.id,
          title: note.title,
          encryptedContent: reEncryptedContent,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
        );

        await _db.updateNote(updatedNote);
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
    }
  }
}
