import 'package:get/get.dart';
import 'package:secret_vault/pages/sv_calculator/sv_calculator_logic.dart';
import 'package:secret_vault/pages/sv_privacy/sv_privacy_logic.dart';
import 'package:secret_vault/pages/sv_settings/sv_settings_logic.dart';
import 'sv_tab_logic.dart';

class SvTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvTabLogic());
    Get.lazyPut(() => SvCalculatorLogic());
    Get.lazyPut(() => SvPrivacyLogic());
    Get.lazyPut(() => SvSettingsLogic());
  }
}
