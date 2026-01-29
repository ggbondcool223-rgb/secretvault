import 'package:get/get.dart';
import 'package:secret_vault/utils/index.dart';

class SvCalculatorDecimalLogic extends GetxController {
  final selectedDecimal = 2.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    selectedDecimal.value = UserPreferences.decimalPlaces;
  }

  Future<void> selectDecimal(int value) async {
    try {
      selectedDecimal.value = value;
      await UserPreferences.setDecimalPlaces(value);
      successToast('Settings saved');
      

      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (e) {
      errorToast('Save failed');
    }
  }
}
