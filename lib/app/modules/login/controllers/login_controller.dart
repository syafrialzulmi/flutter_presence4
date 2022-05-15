import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    isLoading.value = true;
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            isLoading.value = false;
            Get.defaultDialog(
                title: "Email belum Verifikasi",
                middleText:
                    "Kamu belum verifikasi akun ini. Lakukan verifikasi di akun email anda.",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar("Berhasil",
                            "Kami telah berhasil mengirim email verifikasi ke akun anda.");
                      } catch (e) {
                        Get.snackbar("Terjadi Kesalahan",
                            "Tidak dapat mengirim emai verifikasi. Hubungi admmin.");
                      }
                    },
                    child: Text("Kirim Ulang"),
                  ),
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Pengguna email tidak terdaftar.");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang anda masukkan salah.");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login ");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib diisi.");
    }
  }
}
