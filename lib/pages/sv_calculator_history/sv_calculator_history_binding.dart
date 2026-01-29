import 'package:get/get.dart';
import 'sv_calculator_history_logic.dart';

class SvCalculatorHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvCalculatorHistoryLogic());
  }
}
