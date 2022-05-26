import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.hasData) {
              Map<String, dynamic> user = snap.data!.data()!;
              String defaultImageProfile =
                  "https://ui-avatars.com/api/?name=${user['nama']}";
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            user['profile'] != null
                                ? user['profile'] != ""
                                    ? user['profile']
                                    : defaultImageProfile
                                : defaultImageProfile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${user['nama'].toString().toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "${user['email']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                    leading: Icon(Icons.person),
                    title: Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: Icon(Icons.key),
                    title: Text("Update Password"),
                  ),
                  if (user["role"] == "admin")
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      leading: Icon(Icons.person_add),
                      title: Text("Add Pegawai"),
                    ),
                  ListTile(
                    onTap: () {
                      controller.logout();
                    },
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  )
                ],
              );
            } else {
              return Center(
                child: Text("Tidak ada data."),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: "Home"),
          TabItem(icon: Icons.fingerprint, title: "Finger"),
          TabItem(icon: Icons.person, title: "Profile"),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
