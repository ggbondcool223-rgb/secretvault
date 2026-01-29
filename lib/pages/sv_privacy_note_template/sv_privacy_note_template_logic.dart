import 'package:get/get.dart';
import 'package:secret_vault/models/note_template.dart';
import 'package:secret_vault/utils/note_templates.dart';

class SvPrivacyNoteTemplateLogic extends GetxController {
  final categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.value = NoteTemplates.categories;
  }

  List<NoteTemplate> getTemplatesByCategory(String category) {
    return NoteTemplates.getTemplatesByCategory(category);
  }

  void selectTemplate(NoteTemplate template) {

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final title = template.title.replaceAll('[Date]', dateStr);
    final content = template.content.replaceAll('[Date]', dateStr);


    Get.back(result: {
      'title': title,
      'content': content,
    });
  }

  void skipTemplate() {
    Get.back();
  }
}
