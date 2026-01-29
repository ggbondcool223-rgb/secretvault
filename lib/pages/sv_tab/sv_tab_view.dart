import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/pages/sv_calculator/sv_calculator_view.dart';
import 'package:secret_vault/pages/sv_privacy/sv_privacy_view.dart';
import 'package:secret_vault/pages/sv_settings/sv_settings_view.dart';
import 'sv_tab_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SvTabView extends GetView<SvTabLogic> {
  const SvTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SvCalculatorView(),
      const SvPrivacyView(),
      const SvSettingsView(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changeTab(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: const Color(0xFF7F8C8D),
            selectedFontSize: 12.sp,
            unselectedFontSize: 12.sp,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const Icon(Icons.calculate_rounded),
                ),
                label: 'Calculator',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const Icon(Icons.shield_rounded),
                ),
                label: 'Privacy',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const Icon(Icons.settings_rounded),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
