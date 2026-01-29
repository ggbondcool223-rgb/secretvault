import 'package:get/get.dart';
import 'sv_privacy_recover_password_logic.dart';

class SvPrivacyRecoverPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyRecoverPasswordLogic());
  }
}
