import 'package:get/get.dart';
import 'sv_privacy_note_detail_logic.dart';

class SvPrivacyNoteDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyNoteDetailLogic());
  }
}
