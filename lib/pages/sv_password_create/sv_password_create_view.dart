import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sv_password_create_logic.dart';

class SvPasswordCreateView extends GetView<SvPasswordCreateLogic> {
  const SvPasswordCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.ycxfq.value
              ? const CircularProgressIndicator(color: Colors.white)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.tgrc();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
