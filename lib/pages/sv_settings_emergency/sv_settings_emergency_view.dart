import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sv_settings_emergency_logic.dart';

class SvSettingsEmergencyView extends StatelessWidget {
  const SvSettingsEmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SvSettingsEmergencyLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFF2C2E33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Emergency Destroy',
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
                color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE74C3C).withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFE74C3C), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Danger',
                        style: TextStyle(
                          color: Color(0xFFE74C3C),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Emergency destroy mode will permanently delete ALL your private photos, videos, and notes. This action CANNOT be undone!',
                    style: TextStyle(
                      color: Color(0xFFECF0F1),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),


            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF34495E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Emergency Mode',
                          style: TextStyle(
                            color: Color(0xFFECF0F1),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Allow emergency data destruction',
                          style: TextStyle(
                            color: Color(0xFF7F8C8D),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Switch(
                        value: logic.isEnabled.value,
                        onChanged: logic.toggleEmergencyMode,
                        activeThumbColor: const Color(0xFFE74C3C),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 24),


            Obx(() => logic.isEnabled.value
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34495E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency Password',
                          style: TextStyle(
                            color: Color(0xFFECF0F1),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Current emergency password:',
                          style: TextStyle(
                            color: Color(0xFF7F8C8D),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          logic.displayPassword.value,
                          style: const TextStyle(
                            color: Color(0xFFF39C12),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: logic.changeEmergencyPassword,
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: Color(0xFFF39C12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Change Emergency Password',
                              style: TextStyle(color: Color(0xFFF39C12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 32),


            const Text(
              'How it works:',
              style: TextStyle(
                color: Color(0xFFECF0F1),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildStep('1', 'Enable emergency mode and set emergency password'),
            _buildStep('2',
                'In emergency, enter emergency password instead of normal password'),
            _buildStep(
                '3', 'Confirm destruction to delete all private data'),
            _buildStep('4',
                'App will keep calculator function but remove all private content'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFF39C12).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFFF39C12),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFBDC3C7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
