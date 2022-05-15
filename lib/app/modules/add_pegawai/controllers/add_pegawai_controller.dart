import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  void addPegawai() async {
    isLoading.value = true;
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "nama": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createAt": DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification();
        }
        isLoading.value = false;
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          isLoading.value = false;
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat.");
        } else if (e.code == 'email-already-in-use') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada. Kamu tidak bisa menambahkan pegawai dengan email ini.");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, dan Email harus diisi.");
    }
  }
}
