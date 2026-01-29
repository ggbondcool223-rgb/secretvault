import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'user_preferences.dart';
export 'encryption_helper.dart';
export 'media_helper.dart';

void successToast(String msg) {
  Get.snackbar(
    'Success',
    msg,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
  );
}

void errorToast(String msg) {
  Get.snackbar(
    'Error',
    msg,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 1),
  );
}

String getDateString(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String extractDateFromDateTime(String dateTimeString) {
  if (dateTimeString.contains(' ')) {
    return dateTimeString.split(' ')[0];
  }
  return dateTimeString;
}
