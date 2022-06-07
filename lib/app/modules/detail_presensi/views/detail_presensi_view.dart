import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('DETAIL PRESENSI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}"),
                Text(
                    "Posisi : ${data['masuk']['lat']} , ${data['masuk']['long']}"),
                Text("Status : ${data['masuk']['status']}"),
                Text("Address : ${data['masuk']['address']}"),
                Text("Distance : ${data['masuk']['distance']} meter"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['keluar']?['date'] == null
                    ? "Jam : -"
                    : "${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}"),
                Text(data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "Posisi : -"
                    : "Posisi : ${data['keluar']?['lat']} , ${data['keluar']?['long']}"),
                Text(data['keluar']?['address'] == null
                    ? "Address : -"
                    : "Address : ${data['keluar']?['address']}"),
                Text(data['keluar']?['distance'] == null
                    ? "Distance : -"
                    : "Distance : ${data['keluar']?['distance']} meter"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
