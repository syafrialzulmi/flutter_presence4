import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  @override
  Widget build(BuildContext context) {
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
                    "${DateFormat.yMMMEd().format(DateTime.now())}",
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
                Text("${DateFormat.jms().format(DateTime.now())}"),
                Text("-6.123456 , -5.987654"),
                Text("Di dalam area"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${DateFormat.jms().format(DateTime.now())}"),
                Text("-8.123456 , -7.987654"),
                Text("Di luar area"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
