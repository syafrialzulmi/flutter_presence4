import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(user);
    controller.nameC.text = user['nama'];
    controller.emailC.text = user['email'];
    controller.nipC.text = user['nip'];

    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.nipC,
            decoration: InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Photo Profile"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // user['profile'] != null
              //     ? user['profile'] != ""
              //         ? Container(
              //             width: 100,
              //             height: 100,
              //             child: Image.network(
              //               user['profile'],
              //               fit: BoxFit.cover,
              //             ),
              //           )
              //         : Text('no choosen.')
              //     : Text('no choosen.'),
              GetBuilder<UpdateProfileController>(builder: (c) {
                if (c.image != null) {
                  return ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.file(
                        File(c.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  if (user['profile'] != null) {
                    return ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          user['profile'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return Text("no image choosen");
                  }
                }
              }),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: Text('choose'))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updatePegawai(user['uid']);
                  }
                },
                child: Text(controller.isLoading.isFalse
                    ? 'UPDATE PEGAWAI'
                    : 'LOADING...'),
              )),
        ],
      ),
    );
  }
}
