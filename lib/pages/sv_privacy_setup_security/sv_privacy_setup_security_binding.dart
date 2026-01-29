import 'package:get/get.dart';
import 'sv_privacy_setup_security_logic.dart';

class SvPrivacySetupSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacySetupSecurityLogic());
  }
}
