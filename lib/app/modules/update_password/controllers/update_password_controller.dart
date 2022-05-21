import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currentPassC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (currentPassC.text.isNotEmpty &&
        newPassC.text.isNotEmpty &&
        confirmPassC.text.isNotEmpty) {
      isLoading.value = true;
      if (newPassC.text == confirmPassC.text) {
        try {
          String email = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(
              email: email, password: currentPassC.text);

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          Get.back();

          Get.snackbar("Berhasil", "Berhasil Update Password.");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Terjadi Kesalahan",
                "Password yang dimasukkan salah. Tidak dapat update password.");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } finally {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Confirm password tidak cocok.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Semua inputan wajib diisi.");
    }
  }
}
