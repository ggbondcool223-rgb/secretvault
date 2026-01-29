import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_calculator_history_logic.dart';

class SvCalculatorHistoryView extends GetView<SvCalculatorHistoryLogic> {
  const SvCalculatorHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildHistoryList()),
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
            'History',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          _buildHeaderIcon(
            icon: Icons.delete_sweep_rounded,
            onTap: () => controller.clearAllHistory(),
          ),
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

  Widget _buildHistoryList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF39C12),
          ),
        );
      }

      if (controller.historyList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded, size: 64.sp, color: const Color(0xFF34495E)),
              SizedBox(height: 16.h),
              Text(
                'No history yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF7F8C8D),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.historyList.length,
        itemBuilder: (context, index) {
          final item = controller.historyList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Dismissible(
              key: Key(item.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 24.w),
                child: Icon(Icons.delete_outline_rounded, size: 24.sp, color: Colors.white),
              ),
              onDismissed: (direction) {
                controller.deleteHistory(item);
              },
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.onHistoryTap(item),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2E33),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white10, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.expression,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF7F8C8D),
                                  fontFamily: 'Courier',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '= ${item.result}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(Icons.access_time_rounded, size: 12.sp, color: const Color(0xFF5D6D7E)),
                                  SizedBox(width: 4.w),
                                  Text(
                                    controller.formatTime(item.createdAt),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF5D6D7E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: const Color(0xFF34495E)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
