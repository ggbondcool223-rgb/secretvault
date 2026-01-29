import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sv_privacy_setup_security_logic.dart';

class SvPrivacySetupSecurityView extends StatelessWidget {
  const SvPrivacySetupSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SvPrivacySetupSecurityLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFF2C2E33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Security Questions',
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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF34495E).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF39C12).withValues(alpha: 0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFFF39C12),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Important',
                        style: TextStyle(
                          color: Color(0xFFF39C12),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Set up 3 security questions to recover your password if you forget it. Please remember your answers.',
                    style: TextStyle(
                      color: Color(0xFFBDC3C7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),


            Obx(
              () => Column(
                children: List.generate(
                  3,
                  (index) => _buildQuestionSection(logic, index),
                ),
              ),
            ),

            const SizedBox(height: 32),


            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: logic.isSaving.value
                      ? null
                      : () {
                          logic.saveSecurityQuestions();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF39C12),
                    disabledBackgroundColor: const Color(
                      0xFFF39C12,
                    ).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: logic.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSection(SvPrivacySetupSecurityLogic logic, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${index + 1}',
            style: const TextStyle(
              color: Color(0xFFECF0F1),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),


          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF34495E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF7F8C8D).withValues(alpha: 0.3),
              ),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: logic.selectedQuestions[index].value.isEmpty
                  ? null
                  : logic.selectedQuestions[index].value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              dropdownColor: const Color(0xFF34495E),
              style: const TextStyle(color: Color(0xFFECF0F1), fontSize: 13),
              hint: const Text(
                'Select a question',
                style: TextStyle(color: Color(0xFF7F8C8D)),
              ),
              items: logic.getAvailableQuestions(index).map((question) {
                return DropdownMenuItem<String>(
                  value: question,
                  child: Text(question),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  logic.selectQuestion(index, value);
                }
              },
            ),
          ),

          const SizedBox(height: 12),


          TextField(
            controller: logic.answerControllers[index],
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
                  color: const Color(0xFF7F8C8D).withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF7F8C8D).withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF39C12)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
