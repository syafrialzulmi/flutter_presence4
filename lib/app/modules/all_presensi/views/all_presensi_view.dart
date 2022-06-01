import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEMUA PRESENSI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: Text("Search..."),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 20, right: 20, left: 20, top: 10),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PRESENSI);
                      },
                      child: Container(
                        // margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.grey[300],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masuk",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "${DateFormat.yMMMEd().format(DateTime.now())}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text("${DateFormat.jms().format(DateTime.now())}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Keluar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${DateFormat.jms().format(DateTime.now())}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
