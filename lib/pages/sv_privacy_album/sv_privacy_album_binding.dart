import 'package:get/get.dart';
import 'sv_privacy_album_logic.dart';

class SvPrivacyAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyAlbumLogic());
  }
}
