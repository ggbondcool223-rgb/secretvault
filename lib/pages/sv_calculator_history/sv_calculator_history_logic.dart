import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/db_sv/db_sv_entity.dart';
import 'package:secret_vault/utils/index.dart';

class SvCalculatorHistoryLogic extends GetxController {
  final historyList = <CalculatorHistory>[].obs;
  final isLoading = true.obs;
  
  final _db = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }


  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final histories = await _db.getCalculatorHistories();
      historyList.value = histories;
    } catch (e) {
      errorToast('Failed to load history');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteHistory(CalculatorHistory history) async {
    if (history.id == null) return;
    
    try {
      await _db.deleteCalculatorHistory(history.id!);
      historyList.remove(history);
      successToast('Deleted');
    } catch (e) {
      errorToast('Delete failed');
    }
  }


  Future<void> clearAllHistory() async {

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        title: const Text(
          'Clear All History',
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        content: const Text(
          'Are you sure you want to clear all calculation history? This action cannot be undone.',
          style: TextStyle(color: Color(0xFF7F8C8D)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7F8C8D))),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Clear', style: TextStyle(color: Color(0xFFF39C12))),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _db.clearCalculatorHistories();
      historyList.clear();
      successToast('History cleared');
    } catch (e) {
      errorToast('Clear failed');
    }
  }


  void onHistoryTap(CalculatorHistory history) {

    Get.back(result: {
      'expression': history.expression,
      'result': history.result,
    });
  }


  String formatTime(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDateTime;
    }
  }
}
