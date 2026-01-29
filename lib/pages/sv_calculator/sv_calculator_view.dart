import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_calculator_logic.dart';

class SvCalculatorView extends GetView<SvCalculatorLogic> {
  const SvCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(context),
            const Spacer(),
            _buildDisplayArea(),
            _buildQuickActions(),
            _buildKeyboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildHeaderIcon(
                icon: Icons.history_rounded,
                onTap: () async {
                  final result = await Get.toNamed('/calculator/history');
                  if (result != null && result is Map) {
                    controller.loadFromHistory(
                      result['expression'] ?? '',
                      result['result'] ?? '0',
                    );
                  }
                },
              ),
              _buildHeaderIcon(
                icon: Icons.volume_up_rounded,
                onTap: () => Get.toNamed('/calculator/sound'),
              ),
            ],
          ),
          _buildHeaderIcon(
            icon: Icons.settings_outlined,
            onTap: () => Get.toNamed('/calculator/decimal'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Icon(icon, size: 24.sp, color: const Color(0xFFF39C12)),
      ),
    );
  }

  Widget _buildDisplayArea() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Obx(
              () => Text(
                controller.displayExpression.value.isEmpty
                    ? ''
                    : controller.displayExpression.value,
                style: TextStyle(
                  fontSize: 22.sp,
                  color: const Color(0xFF7F8C8D),
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          SizedBox(
            height: 66.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Obx(
                () => SizedBox(
                  height: 66.h,
                  child: Center(
                    child: Text(
                      controller.currentInput,
                      style: TextStyle(
                        fontSize: controller.showUppercase.value
                            ? 38.sp
                            : 56.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.copy_all_rounded,
              label: 'Copy',
              onTap: () => controller.onCopyTap(),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Obx(
              () => _buildActionButton(
                icon: Icons.text_fields_rounded,
                label: 'Uppercase',
                onTap: () => controller.onUppercaseTap(),
                isEnabled: controller.canConvertUppercase,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isEnabled
                ? const Color(0xFF2C2E33)
                : const Color(0xFF1A1B1E),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isEnabled
                  ? Colors.white10
                  : Colors.white.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isEnabled
                    ? const Color(0xFFF39C12)
                    : const Color(0xFF4A4A4A),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isEnabled
                      ? const Color(0xFFECF0F1)
                      : const Color(0xFF5A5A5A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
      child: Column(
        children: [
          _buildKeyRow(['C', '+/-', '%', '÷']),
          SizedBox(height: 10.h),
          _buildKeyRow(['7', '8', '9', '×']),
          SizedBox(height: 10.h),
          _buildKeyRow(['4', '5', '6', '-']),
          SizedBox(height: 10.h),
          _buildKeyRow(['1', '2', '3', '+']),
          SizedBox(height: 10.h),
          _buildKeyRow(['·', '0', '←', '=']),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: key == keys.last ? 0 : 10.w),
            child: _buildKey(
              key,
              isOperator: ['÷', '×', '-', '+', '='].contains(key),
              isClear: key == 'C',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey(
    String label, {
    bool isOperator = false,
    bool isClear = false,
  }) {

    bool isFunctionKey = ['C', '+/-', '%', '←'].contains(label);

    Color bgColor;
    Color textColor = Colors.white;
    if (isFunctionKey) {
      bgColor = const Color(0xFF3D4046);
      textColor = label == 'C' ? const Color(0xFFF39C12) : Colors.white;
    } else if (isOperator) {
      bgColor = const Color(0xFFF39C12);
    } else {
      bgColor = const Color(0xFF2C2E33);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.onKeyTap(label),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          height: 72.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              if (!isOperator)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child: label == '←'
                ? Icon(Icons.backspace_outlined, size: 24.sp, color: textColor)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
