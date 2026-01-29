import 'package:get/get.dart';
import 'sv_privacy_set_password_logic.dart';

class SvPrivacySetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacySetPasswordLogic());
  }
}
