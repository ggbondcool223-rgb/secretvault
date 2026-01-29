import 'package:get/get.dart';

import 'sv_password_create_logic.dart';

class SvPasswordCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SvPasswordCreateLogic(),
      permanent: true,
    );
  }
}
