import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/models/note_template.dart';
import 'sv_privacy_note_template_logic.dart';

class SvPrivacyNoteTemplateView extends StatelessWidget {
  const SvPrivacyNoteTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SvPrivacyNoteTemplateLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFF2C2E33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Choose Template',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFECF0F1)),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: logic.skipTemplate,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFFF39C12),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logic.categories.length,
            itemBuilder: (context, index) {
              final category = logic.categories[index];
              final templates = logic.getTemplatesByCategory(category);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, top: 16, bottom: 12),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFFF39C12),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...templates
                      .map((template) => _buildTemplateCard(logic, template)),
                ],
              );
            },
          )),
    );
  }

  Widget _buildTemplateCard(
      SvPrivacyNoteTemplateLogic logic, NoteTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => logic.selectTemplate(template),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF34495E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF7F8C8D).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [

                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2E33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      template.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),


                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: const TextStyle(
                          color: Color(0xFFECF0F1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        template.content
                            .split('\n')
                            .first
                            .replaceAll(RegExp(r'[^\w\s]'), ''),
                        style: const TextStyle(
                          color: Color(0xFF7F8C8D),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),


                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7F8C8D),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
