import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/crypto_utils.dart';
import 'package:secret_vault/utils/index.dart';
import 'package:secret_vault/utils/security_questions.dart';

class SvPrivacySetupSecurityLogic extends GetxController {
  final selectedQuestions = List.generate(3, (_) => ''.obs);
  final answerControllers = List.generate(3, (_) => TextEditingController());
  final isSaving = false.obs;

  final _db = Get.find<DatabaseService>();

  List<String> getAvailableQuestions(int currentIndex) {
    final selected = selectedQuestions
        .asMap()
        .entries
        .where(
          (entry) => entry.key != currentIndex && entry.value.value.isNotEmpty,
        )
        .map((entry) => entry.value.value)
        .toList();

    return SecurityQuestions.predefinedQuestions
        .where((q) => !selected.contains(q))
        .toList();
  }

  void selectQuestion(int index, String question) {
    selectedQuestions[index].value = question;
  }

  Future<void> saveSecurityQuestions() async {
    if (isSaving.value) {
      return;
    }

    isSaving.value = true;

    try {

      for (int i = 0; i < 3; i++) {
        if (selectedQuestions[i].value.isEmpty) {
          isSaving.value = false;
          errorToast('Please select question ${i + 1}');
          return;
        }

        if (answerControllers[i].text.trim().isEmpty) {
          isSaving.value = false;
          errorToast('Please answer question ${i + 1}');
          return;
        }
      }



      final password = await _db.getPassword();
      if (password == null) {
        isSaving.value = false;
        errorToast('Password not set');
        return;
      }



      await _db.deleteAllSecurityQuestions();


      for (int i = 0; i < 3; i++) {
        final encryptedAnswer = CryptoUtils.encryptText(
          answerControllers[i].text.trim().toLowerCase(),
          password.encryptedPassword,
        );

        final question = SecurityQuestion(
          question: selectedQuestions[i].value,
          encryptedAnswer: encryptedAnswer,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _db.insertSecurityQuestion(question);
      }



      await Future.delayed(const Duration(milliseconds: 800));
      Get.back();
    } catch (e) {
      isSaving.value = false;
      errorToast('Failed to save security questions');
    }
  }

  @override
  void onClose() {
    for (var controller in answerControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
