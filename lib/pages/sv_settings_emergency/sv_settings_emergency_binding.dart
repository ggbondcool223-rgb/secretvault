import 'package:get/get.dart';
import 'sv_settings_emergency_logic.dart';

class SvSettingsEmergencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvSettingsEmergencyLogic());
  }
}
