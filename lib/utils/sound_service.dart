import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:secret_vault/utils/user_preferences.dart';

class SoundService extends GetxService {
  late AudioPlayer _player;

  @override
  void onInit() {
    super.onInit();
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  Future<void> playKeySound() async {
    final soundType = UserPreferences.soundType;
    await _playSound(soundType);
  }

  Future<void> playPreviewSound(String soundType) async {
    await _playSound(soundType);
  }

  Future<void> _playSound(String soundType) async {
    if (soundType == 'off') {
      return;
    }

    try {
      await _player.stop();

      String soundPath = _getSoundPath(soundType);

      await _player.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint('Error playing key sound: $e');
    }
  }

  String _getSoundPath(String soundType) {
    switch (soundType) {
      case 'default':
        return 'sounds/click_default.wav';
      case 'sound1':
        return 'sounds/click_sound1.wav';
      case 'sound2':
        return 'sounds/click_sound2.wav';
      case 'sound3':
        return 'sounds/click_sound3.wav';
      default:
        return 'sounds/click_default.wav';
    }
  }

  static Future<void> playClick() async {
    try {
      final service = Get.find<SoundService>();
      await service.playKeySound();
    } catch (e) {
      debugPrint('Error playing click sound: $e');
    }
  }
}
