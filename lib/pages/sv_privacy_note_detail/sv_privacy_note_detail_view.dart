import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_privacy_note_detail_logic.dart';

class SvPrivacyNoteDetailView extends GetView<SvPrivacyNoteDetailLogic> {
  const SvPrivacyNoteDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            onPressed: () => controller.onSaveTap(),
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF39C12)),
          );
        }

        return Column(children: [Expanded(child: _buildContent())]);
      }),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: EdgeInsets.all(24.w),
      children: [
        TextField(
          controller: controller.titleController,
          maxLength: 50,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFECF0F1),
          ),
          decoration: InputDecoration(
            hintText: 'Note Title',
            hintStyle: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7F8C8D),
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            counterText: '',
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: controller.contentController,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFFECF0F1),
            height: 1.6,
          ),
          decoration: InputDecoration(
            hintText: 'Start writing...',
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF7F8C8D),
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          maxLines: null,
          minLines: 20,
        ),
      ],
    );
  }
}
