import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_calculator_decimal_logic.dart';

class SvCalculatorDecimalView extends GetView<SvCalculatorDecimalLogic> {
  const SvCalculatorDecimalView({super.key});

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
            'Decimal Settings',
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
      child: Text(
        'Select decimal places for calculation results',
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF7F8C8D),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 9,
      itemBuilder: (context, index) {
        final value = index + 1;
        return Obx(() {
          final isSelected = controller.selectedDecimal.value == value;
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectDecimal(value),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
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
                      Text(
                        '$value decimal place${value > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : const Color(0xFFECF0F1),
                        ),
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
