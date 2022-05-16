import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoading2 = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  TextEditingController passAdminC = TextEditingController();

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        isLoading2.value = true;
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

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

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai.");
        }
        isLoading.value = false;
        isLoading2.value = false;
        // print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          isLoading.value = false;
          isLoading2.value = false;
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat.");
        } else if (e.code == 'email-already-in-use') {
          isLoading.value = false;
          isLoading2.value = false;
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada. Kamu tidak bisa menambahkan pegawai dengan email ini.");
        } else if (e.code == 'wrong-password') {
          isLoading.value = false;
          isLoading2.value = false;
          Get.snackbar("Terjadi Kesalahan", "Password yang masukkan salah.");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        isLoading.value = false;
        isLoading2.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Password harus diisi, untuk keperluan validasi.");
    }
  }

  Future<void> addPegawai() async {
    isLoading.value = true;
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text("Masukkan password untuk validasi admin."),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text("CANCEL"),
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (isLoading2.isFalse) {
                    await prosesAddPegawai();
                  }
                },
                child: Text(isLoading2.isFalse ? "ADD PEGAWAI" : "LOADING..."),
              )),
        ],
      );
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, dan Email harus diisi.");
    }
  }
}
