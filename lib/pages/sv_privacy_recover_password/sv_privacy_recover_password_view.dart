import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sv_privacy_recover_password_logic.dart';

class SvPrivacyRecoverPasswordView extends StatelessWidget {
  const SvPrivacyRecoverPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SvPrivacyRecoverPasswordLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFF2C2E33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Recover Password',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFECF0F1)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Obx(() => _buildProgressIndicator(logic.currentQuestionIndex.value)),

            const SizedBox(height: 32),


            Obx(() {
              if (logic.questions.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF39C12)),
                );
              }

              final questionIndex = logic.currentQuestionIndex.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${questionIndex + 1} of 3',
                    style: const TextStyle(
                      color: Color(0xFF7F8C8D),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34495E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFF39C12).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      logic.questions[questionIndex],
                      style: const TextStyle(
                        color: Color(0xFFECF0F1),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: logic.answerControllers[questionIndex],
                    obscureText: true,
                    style: const TextStyle(color: Color(0xFFECF0F1)),
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                      hintStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                      filled: true,
                      fillColor: const Color(0xFF34495E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: const Color(0xFF7F8C8D).withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: const Color(0xFF7F8C8D).withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF39C12)),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: logic.submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        questionIndex < 2 ? 'Next' : 'Verify',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      children: List.generate(3, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? const Color(0xFFF39C12)
                  : const Color(0xFF7F8C8D).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
