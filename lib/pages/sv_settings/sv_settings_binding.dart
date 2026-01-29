import 'package:get/get.dart';
import 'sv_settings_logic.dart';

class SvSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvSettingsLogic());
  }
}
