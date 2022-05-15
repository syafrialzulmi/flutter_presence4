import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    isLoading.value = true;
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          await auth.currentUser!.updatePassword(newPassC.text);
          String email = auth.currentUser!.email!;

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          isLoading.value = false;
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          isLoading.value = false;
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan",
                "Password terlalu lemah. 6 karakte lebih.");
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat membuat password baru. Hubungi admmin.");
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan",
            "Password baru harus diubah, jangan 'password' kembali.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password baru wajib diisi.");
    }
  }
}
