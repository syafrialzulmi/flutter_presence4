import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamRole(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }
                String role = snap.data!.data()!["role"];
                if (role == "admin") {
                  return IconButton(
                    onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
                    icon: Icon(Icons.person),
                  );
                } else {
                  return SizedBox();
                }
              }),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Get.offAllNamed(Routes.LOGIN);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
