import 'package:get/get.dart';

class SvTabLogic extends GetxController {
  final currentIndex = 0.obs;
  final isPrivacyAuthenticated = false.obs;

  Future<void> changeTab(int index) async {
    

    if (index == 1 && !isPrivacyAuthenticated.value) {
      

      final result = await Get.toNamed(
        '/privacy/set_password',
        arguments: {'isEnteringPrivacy': true},
      );
      
      

      if (result == true) {
        isPrivacyAuthenticated.value = true;
        currentIndex.value = 1;
      } else {

        currentIndex.value = 0;
      }
    } else {

      currentIndex.value = index;
      

      if (index != 1) {
        isPrivacyAuthenticated.value = false;
      }
    }
    
  }
}
