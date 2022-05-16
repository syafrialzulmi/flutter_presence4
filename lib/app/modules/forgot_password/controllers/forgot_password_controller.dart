import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    isLoading.value = true;
    if (emailC.text.isNotEmpty) {
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil",
            "Berhasil mengirim email reset password. Cek email anda.");
        Get.toNamed(Routes.LOGIN);
      } catch (e) {
        Get.snackbar(
            "Terjadi Kesalahan", "Tidak dapat mengirim email reset password.");
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Email wajib diisi.");
    }
  }
}
