import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/crypto_utils.dart';
import 'package:secret_vault/utils/index.dart';

enum PasswordMode { set, verify }

class SvPrivacySetPasswordLogic extends GetxController {
  final password = ''.obs;
  final passwordDots = <bool>[].obs;
  final mode = PasswordMode.set.obs;
  final title = 'Set Password'.obs;
  final instruction = 'Please enter a 6-digit password'.obs;

  String _firstPassword = '';
  String? _targetRoute;
  bool _isEnteringPrivacy = false;

  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    _checkMode();
  }

  Future<void> _checkMode() async {

    final args = Get.arguments as Map<String, dynamic>?;
    _targetRoute = args?['targetRoute'] as String?;
    _isEnteringPrivacy = args?['isEnteringPrivacy'] as bool? ?? false;


    final existingPassword = await _db.getPassword();

    if (existingPassword != null) {

      mode.value = PasswordMode.verify;
      title.value = 'Verify Password';
      instruction.value = 'Please enter your password';
    } else {

      mode.value = PasswordMode.set;
      title.value = 'Set Password';
      instruction.value = 'Please enter a 6-digit password';
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
    if (mode.value == PasswordMode.set) {
      await _handleSetPassword();
    } else {
      await _handleVerifyPassword();
    }
  }

  Future<void> _handleSetPassword() async {
    if (_firstPassword.isEmpty) {

      _firstPassword = password.value;
      title.value = 'Confirm Password';
      instruction.value = 'Please enter the password again';
      clear();
    } else {

      if (_firstPassword == password.value) {
        await _savePassword(_firstPassword);
      } else {
        errorToast('Passwords do not match');
        HapticFeedback.vibrate();
        _firstPassword = '';
        title.value = 'Set Password';
        instruction.value = 'Please enter a 6-digit password';
        clear();
      }
    }
  }

  Future<void> _savePassword(String pwd) async {
    try {
      final encryptedPassword = CryptoUtils.hashPassword(pwd);
      final passwordEntity = Password(
        encryptedPassword: encryptedPassword,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _db.insertPassword(passwordEntity);
      await UserPreferences.setFirstTimePassword(false);
      await UserPreferences.resetPasswordAttempts();

      await Future.delayed(const Duration(milliseconds: 500));


      final shouldSetupSecurity = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF34495E),
          title: const Text(
            'Set Up Security Questions',
            style: TextStyle(color: Color(0xFFECF0F1)),
          ),
          content: const Text(
            'Set up security questions to recover your password if you forget it. (Recommended)',
            style: TextStyle(color: Color(0xFFBDC3C7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Skip',
                style: TextStyle(color: Color(0xFF7F8C8D)),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                'Set Up',
                style: TextStyle(color: Color(0xFFF39C12)),
              ),
            ),
          ],
        ),
      );

      if (shouldSetupSecurity == true) {
        await Get.toNamed('/privacy/setup_security_questions');
      }




      if (_isEnteringPrivacy) {

        Get.back(result: true);
      } else if (_targetRoute != null) {

        Get.offAllNamed(_targetRoute!);
      } else {

        Get.back(result: true);
      }
    } catch (e) {
      errorToast('Failed to save password');
      clear();
    }
  }

  Future<void> _handleVerifyPassword() async {
    try {

      if (UserPreferences.emergencyModeEnabled) {
        final emergencyPassword = UserPreferences.emergencyPassword;
        if (emergencyPassword != null &&
            CryptoUtils.verifyPassword(password.value, emergencyPassword)) {

          await _handleEmergencyDestroy();
          return;
        }
      }

      final existingPassword = await _db.getPassword();
      if (existingPassword == null) {
        errorToast('Password not set');
        Get.back();
        return;
      }


      final lockTime = UserPreferences.passwordLockTime;
      if (lockTime != null) {
        final lockDateTime = DateTime.parse(lockTime);
        final now = DateTime.now();
        final diff = now.difference(lockDateTime);

        if (diff.inSeconds < 30) {
          final remaining = 30 - diff.inSeconds;
          errorToast('Locked. Try again in $remaining seconds');
          HapticFeedback.vibrate();
          clear();
          return;
        } else {

          await UserPreferences.setPasswordLockTime(null);
          await UserPreferences.resetPasswordAttempts();
        }
      }


      if (CryptoUtils.verifyPassword(
        password.value,
        existingPassword.encryptedPassword,
      )) {

        await UserPreferences.resetPasswordAttempts();

        await Future.delayed(const Duration(milliseconds: 300));


        if (_isEnteringPrivacy) {

          Get.back(result: true);
        } else if (_targetRoute != null) {

          Get.offAllNamed(_targetRoute!);
        } else {

          Get.back(result: true);
        }
      } else {

        await UserPreferences.incrementPasswordAttempts();
        final attempts = UserPreferences.passwordAttempts;

        if (attempts >= 3) {

          await UserPreferences.setPasswordLockTime(
            DateTime.now().toIso8601String(),
          );
          HapticFeedback.vibrate();

          Get.back(result: false);
        } else {
          errorToast('Wrong password. ${3 - attempts} attempts left');
          HapticFeedback.vibrate();
          clear();
        }
      }
    } catch (e) {
      errorToast('Verification failed');
      clear();
    }
  }

  Future<void> _handleEmergencyDestroy() async {

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFE74C3C), size: 28),
            SizedBox(width: 12),
            Text('Emergency Destroy', style: TextStyle(color: Color(0xFFE74C3C))),
          ],
        ),
        content: const Text(
          'This will permanently delete ALL your private data. This action CANNOT be undone!\n\nContinue?',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF7F8C8D))),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Destroy All Data',
              style:
                  TextStyle(color: Color(0xFFE74C3C), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      clear();
      return;
    }


    Get.dialog(
      const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFFE74C3C)),
            SizedBox(height: 16),
            Text('Destroying data...',
                style: TextStyle(color: Color(0xFFECF0F1))),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {

      final mediaDir = await MediaHelper.getPrivateDirectory();
      if (await mediaDir.exists()) {
        await mediaDir.delete(recursive: true);
      }

      final thumbnailDir = await MediaHelper.getThumbnailDirectory();
      if (await thumbnailDir.exists()) {
        await thumbnailDir.delete(recursive: true);
      }


      final db = await _db.database;
      await db.delete('media');
      await db.delete('album');
      await db.delete('note');
      await db.delete('password');
      await db.delete('security_question');


      await UserPreferences.setFirstTimePassword(true);
      await UserPreferences.setEmergencyModeEnabled(false);
      await UserPreferences.resetPasswordAttempts();


      Get.back();


      await Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF34495E),
          title: const Text('Data Destroyed',
              style: TextStyle(color: Color(0xFFECF0F1))),
          content: const Text(
            'All private data has been permanently deleted.',
            style: TextStyle(color: Color(0xFF7F8C8D)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFF39C12))),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.back();
      errorToast('Failed to destroy data');
      clear();
    }
  }

  Future<void> onForgotPassword() async {

    final questions = await _db.getSecurityQuestions();

    if (questions.length < 3) {
      await Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF34495E),
          title: const Text(
            'Security Questions Not Set',
            style: TextStyle(color: Color(0xFFECF0F1)),
          ),
          content: const Text(
            'You haven\'t set up security questions. Please contact support or reinstall the app (all data will be lost).',
            style: TextStyle(color: Color(0xFFBDC3C7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFF39C12)),
              ),
            ),
          ],
        ),
      );
    } else {
      Get.toNamed('/privacy/recover_password');
    }
  }
}
