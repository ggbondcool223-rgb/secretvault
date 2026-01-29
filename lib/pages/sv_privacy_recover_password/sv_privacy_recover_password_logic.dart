import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/crypto_utils.dart';
import 'package:secret_vault/utils/index.dart';

class SvPrivacyRecoverPasswordLogic extends GetxController {
  final currentQuestionIndex = 0.obs;
  final questions = <String>[].obs;
  final answerControllers = List.generate(3, (_) => TextEditingController());

  final _db = Get.find<DatabaseService>();
  List<SecurityQuestion> _securityQuestions = [];

  @override
  void onInit() {
    super.onInit();
    _loadSecurityQuestions();
  }

  Future<void> _loadSecurityQuestions() async {
    try {
      _securityQuestions = await _db.getSecurityQuestions();

      if (_securityQuestions.length < 3) {
        errorToast('Security questions not set up');
        Get.back();
        return;
      }

      questions.value = _securityQuestions.map((q) => q.question).toList();
    } catch (e) {
      errorToast('Failed to load security questions');
      Get.back();
    }
  }

  Future<void> submitAnswer() async {
    final answer = answerControllers[currentQuestionIndex.value].text.trim();

    if (answer.isEmpty) {
      errorToast('Please enter an answer');
      return;
    }

    try {

      final password = await _db.getPassword();
      if (password == null) {
        errorToast('Password not found');
        return;
      }

      final correctAnswer = CryptoUtils.decryptText(
        _securityQuestions[currentQuestionIndex.value].encryptedAnswer,
        password.encryptedPassword,
      );

      if (answer.toLowerCase() == correctAnswer.toLowerCase()) {

        if (currentQuestionIndex.value < 2) {

          currentQuestionIndex.value++;
        } else {

          successToast('Verification successful');
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offNamed('/settings/reset_password', arguments: {
            'skipOldPassword': true,
          });
        }
      } else {

        errorToast('Wrong answer');
        HapticFeedback.vibrate();
        answerControllers[currentQuestionIndex.value].clear();
      }
    } catch (e) {
      errorToast('Verification failed');
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
