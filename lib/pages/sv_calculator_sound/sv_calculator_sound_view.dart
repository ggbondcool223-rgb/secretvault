import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_calculator_sound_logic.dart';

class SvCalculatorSoundView extends GetView<SvCalculatorSoundLogic> {
  const SvCalculatorSoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSubHeader(),
            Expanded(child: _buildOptionsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back(),
          ),
          Text(
            'Key Sound',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Icon(icon, size: 22.sp, color: const Color(0xFFF39C12)),
      ),
    );
  }

  Widget _buildSubHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select key press sound effect',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF7F8C8D),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap an option to preview and save',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF95A5A6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    final soundOptions = [
      {'icon': Icons.volume_off_rounded, 'label': 'Off'},
      {'icon': Icons.volume_down_rounded, 'label': 'Default Sound'},
      {'icon': Icons.music_note_rounded, 'label': 'Sound Effect 1'},
      {'icon': Icons.music_note_rounded, 'label': 'Sound Effect 2'},
      {'icon': Icons.music_note_rounded, 'label': 'Sound Effect 3'},
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: soundOptions.length,
      itemBuilder: (context, index) {
        final option = soundOptions[index];
        final label = option['label'] as String;
        return Obx(() {
          final isSelected = controller.selectedSound.value == label;
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectSound(label),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF39C12).withValues(alpha: 0.1) : const Color(0xFF2C2E33),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF39C12).withValues(alpha: 0.5) : Colors.white10,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            option['icon'] as IconData,
                            size: 22.sp,
                            color: isSelected ? const Color(0xFFF39C12) : const Color(0xFF7F8C8D),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : const Color(0xFFECF0F1),
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded, size: 20.sp, color: const Color(0xFFF39C12)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
