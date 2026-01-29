import 'package:get/get.dart';
import 'sv_privacy_album_detail_logic.dart';

class SvPrivacyAlbumDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SvPrivacyAlbumDetailLogic());
  }
}
