import 'package:get/get.dart';
import 'sv_calculator_sound_logic.dart';

class SvCalculatorSoundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvCalculatorSoundLogic());
  }
}
