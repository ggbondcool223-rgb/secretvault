import 'package:get/get.dart';
import 'sv_privacy_logic.dart';

class SvPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyLogic());
  }
}
