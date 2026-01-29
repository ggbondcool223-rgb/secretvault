import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_settings_reset_password_logic.dart';

class SvSettingsResetPasswordView
    extends GetView<SvSettingsResetPasswordLogic> {
  const SvSettingsResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(color: Colors.white10, height: 1.h),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 24.h),
                  _buildLockIcon(),
                  SizedBox(height: 24.h),
                  _buildStepIndicator(),
                  SizedBox(height: 16.h),
                  _buildInstruction(),
                  SizedBox(height: 16.h),
                  _buildPasswordDots(),
                  SizedBox(height: 48.h),
                  _buildNumberPad(),
                ],
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
        Icons.lock_reset_rounded,
        size: 40.sp,
        color: const Color(0xFFF39C12),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2E33),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFF39C12).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        controller.stepTitle,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFF39C12),
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return Text(
      controller.stepDescription,
      style: TextStyle(fontSize: 18.sp, color: const Color(0xFFECF0F1)),
    );
  }

  Widget _buildPasswordDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < controller.passwordDots.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: isFilled ? const Color(0xFFF39C12) : const Color(0xFF2C2E33),
            shape: BoxShape.circle,
            border: Border.all(
              color: isFilled ? const Color(0xFFF39C12) : Colors.white10,
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildNumberRow(['1', '2', '3']),
        SizedBox(height: 24.h),
        _buildNumberRow(['4', '5', '6']),
        SizedBox(height: 24.h),
        _buildNumberRow(['7', '8', '9']),
        SizedBox(height: 24.h),
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
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
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
