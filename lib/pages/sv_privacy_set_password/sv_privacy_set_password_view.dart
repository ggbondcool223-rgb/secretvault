import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_privacy_set_password_logic.dart';

class SvPrivacySetPasswordView extends GetView<SvPrivacySetPasswordLogic> {
  const SvPrivacySetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {

          Get.back(result: false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF17181A),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  _buildLockIcon(),
                  SizedBox(height: 32.h),
                  _buildInstruction(),
                  SizedBox(height: 16.h),
                  _buildPasswordDots(),
                  SizedBox(height: 48.h),
                  _buildNumberPad(),
                  const SizedBox(height: 16),

                  Obx(() => controller.mode.value == PasswordMode.verify
                      ? TextButton(
                          onPressed: controller.onForgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFFF39C12),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(result: false),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: const Color(0xFFECF0F1),
                ),
              ),
            ),
          ),
          Obx(
            () => Text(
              controller.title.value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFECF0F1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockIcon() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2E33),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        size: 40.sp,
        color: const Color(0xFFF39C12),
      ),
    );
  }

  Widget _buildInstruction() {
    return Obx(
      () => Text(
        controller.instruction.value,
        style: TextStyle(fontSize: 18.sp, color: const Color(0xFFECF0F1)),
      ),
    );
  }

  Widget _buildPasswordDots() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final isFilled = index < controller.passwordDots.length;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: isFilled
                  ? const Color(0xFFF39C12)
                  : const Color(0xFF2C2E33),
              shape: BoxShape.circle,
              border: Border.all(
                color: isFilled ? const Color(0xFFF39C12) : Colors.white10,
                width: 1,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildNumberRow(['1', '2', '3']),
        SizedBox(height: 18.h),
        _buildNumberRow(['4', '5', '6']),
        SizedBox(height: 18.h),
        _buildNumberRow(['7', '8', '9']),
        SizedBox(height: 18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 80.w, height: 80.w),
            SizedBox(width: 24.w),
            _buildNumberButton('0'),
            SizedBox(width: 24.w),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.deleteNumber(),
                borderRadius: BorderRadius.circular(40.r),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D4046),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 24.sp,
                    color: const Color(0xFFECF0F1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          color: Colors.transparent,
          child: _buildNumberButton(number),
        );
      }).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.addNumber(number),
        borderRadius: BorderRadius.circular(40.r),
        child: Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2E33),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
