import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/utils/index.dart';

class SvSettingsEmergencyLogic extends GetxController {
  final isEnabled = false.obs;
  final displayPassword = '000000'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    isEnabled.value = UserPreferences.emergencyModeEnabled;
    final savedPassword = UserPreferences.emergencyPassword;
    if (savedPassword != null) {

      displayPassword.value = '000000';
    }
  }

  Future<void> toggleEmergencyMode(bool value) async {
    if (value) {

      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF34495E),
          title: const Text(
            'Enable Emergency Mode',
            style: TextStyle(color: Color(0xFFECF0F1)),
          ),
          content: const Text(
            'This will set up emergency password. Entering this password will destroy all private data. Continue?',
            style: TextStyle(color: Color(0xFFBDC3C7)),
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
                'Enable',
                style: TextStyle(color: Color(0xFFE74C3C)),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await UserPreferences.setEmergencyPassword('000000');
        await UserPreferences.setEmergencyModeEnabled(true);
        isEnabled.value = true;
        displayPassword.value = '000000';
        successToast('Emergency mode enabled');
      }
    } else {

      await UserPreferences.setEmergencyModeEnabled(false);
      isEnabled.value = false;
      successToast('Emergency mode disabled');
    }
  }

  Future<void> changeEmergencyPassword() async {

    final controller = TextEditingController();

    final newPassword = await Get.dialog<String>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Change Emergency Password',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: const TextStyle(color: Color(0xFFECF0F1)),
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit password',
            hintStyle: TextStyle(color: Color(0xFF7F8C8D)),
            counterText: '',
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
            onPressed: () => Get.back(result: controller.text),
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFFF39C12)),
            ),
          ),
        ],
      ),
    );

    if (newPassword != null && newPassword.length == 6) {
      await UserPreferences.setEmergencyPassword(newPassword);
      displayPassword.value = newPassword;
      successToast('Emergency password updated');
    } else if (newPassword != null) {
      errorToast('Password must be 6 digits');
    }
  }
}
