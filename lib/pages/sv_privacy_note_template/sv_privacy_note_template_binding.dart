import 'package:get/get.dart';
import 'sv_privacy_note_template_logic.dart';

class SvPrivacyNoteTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyNoteTemplateLogic());
  }
}
