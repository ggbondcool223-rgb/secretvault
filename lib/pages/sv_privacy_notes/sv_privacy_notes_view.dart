import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sv_privacy_notes_logic.dart';

class SvPrivacyNotesView extends GetView<SvPrivacyNotesLogic> {
  const SvPrivacyNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Private Notes')),
      body: SafeArea(
        child: Stack(
          children: [
            Column(children: [Expanded(child: _buildNotesList())]),
            _buildFAB(),
          ],
        ),
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
        child: Icon(icon, size: 22.sp, color: const Color(0xFFF39C12)),
      ),
    );
  }

  Widget _buildNotesList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFF39C12)),
        );
      }

      if (controller.notes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_alt_rounded,
                size: 64.sp,
                color: const Color(0xFF34495E),
              ),
              SizedBox(height: 16.h),
              Text(
                'No notes yet',
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: controller.notes.length,
        itemBuilder: (context, index) {
          final note = controller.notes[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.onNoteTap(note),
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
                              note.title.isEmpty ? 'Untitled Note' : note.title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12.sp,
                                  color: const Color(0xFF5D6D7E),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  controller.formatTime(note.updatedAt),
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
                      _buildHeaderIcon(
                        icon: Icons.more_horiz_rounded,
                        onTap: () => controller.showNoteMenu(note),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: 24.h,
      right: 24.w,
      child: FloatingActionButton(
        onPressed: () => controller.createNote(),
        backgroundColor: const Color(0xFFF39C12),
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add_rounded, size: 32.sp, color: Colors.white),
      ),
    );
  }
}
