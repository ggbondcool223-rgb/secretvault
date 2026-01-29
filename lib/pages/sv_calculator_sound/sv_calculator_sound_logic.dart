import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:secret_vault/utils/index.dart';
import 'package:secret_vault/utils/sound_service.dart';

class SvCalculatorSoundLogic extends GetxController {
  final selectedSound = 'Off'.obs;
  final isPlaying = false.obs;

  final soundTypeMap = {
    'Off': 'off',
    'Default Sound': 'default',
    'Sound Effect 1': 'sound1',
    'Sound Effect 2': 'sound2',
    'Sound Effect 3': 'sound3',
  };

  final soundLabelMap = {
    'off': 'Off',
    'default': 'Default Sound',
    'sound1': 'Sound Effect 1',
    'sound2': 'Sound Effect 2',
    'sound3': 'Sound Effect 3',
  };

  late SoundService _soundService;

  @override
  void onInit() {
    super.onInit();
    _soundService = Get.find<SoundService>();
    _loadSettings();
  }


  void _loadSettings() {
    final soundType = UserPreferences.soundType;
    selectedSound.value = soundLabelMap[soundType] ?? 'Default Sound';
  }

  Future<void> selectSound(String label) async {
    try {

      if (isPlaying.value) {
        return;
      }

      isPlaying.value = true;
      selectedSound.value = label;
      final soundType = soundTypeMap[label] ?? 'default';



      await _playPreviewSound(soundType);


      final saved = await UserPreferences.setSoundType(soundType);

      if (saved) {
      } else {
        throw Exception('Failed to save sound type');
      }
    } catch (e) {
      errorToast('Save failed');
    } finally {

      await Future.delayed(const Duration(milliseconds: 300));
      isPlaying.value = false;
    }
  }

  Future<void> _playPreviewSound(String soundType) async {
    try {
      await _soundService.playPreviewSound(soundType);
    } catch (e) {
      debugPrint('Error playing preview sound: $e');
    }
  }


  Future<void> testCurrentSound() async {
    try {
      final soundType = soundTypeMap[selectedSound.value] ?? 'default';
      await _playPreviewSound(soundType);
    } catch (e) {
      debugPrint('Error saving sound preference: $e');
    }
  }
}
