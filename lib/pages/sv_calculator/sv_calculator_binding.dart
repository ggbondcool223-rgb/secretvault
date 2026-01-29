import 'package:get/get.dart';
import 'sv_calculator_logic.dart';

class SvCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvCalculatorLogic());
  }
}
