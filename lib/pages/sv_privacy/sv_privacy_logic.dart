import 'package:get/get.dart';

class SvPrivacyLogic extends GetxController {
  void onPrivateAlbumTap() {
    Get.toNamed('/privacy/album');
  }

  void onPrivateNotesTap() {
    Get.toNamed('/privacy/notes');
  }
}
