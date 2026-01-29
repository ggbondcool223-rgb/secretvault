import 'package:get/get.dart';
import 'sv_privacy_notes_logic.dart';

class SvPrivacyNotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyNotesLogic());
  }
}
