import 'package:get/get.dart';
import 'sv_settings_reset_password_logic.dart';

class SvSettingsResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvSettingsResetPasswordLogic());
  }
}
