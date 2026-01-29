import 'package:get/get.dart';
import 'sv_calculator_decimal_logic.dart';

class SvCalculatorDecimalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvCalculatorDecimalLogic());
  }
}
