import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence4/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> changePage(int i) async {
    // pageIndex.value = i;
    switch (i) {
      case 1:
        // print('ABSENSI');
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          // print("${position.latitude}, ${position.longitude}");
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          // print(placemarks[0]);
          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosistion(position, address);

          // area jangkauan
          double distance = Geolocator.distanceBetween(
              -6.963444, 110.4619592, position.latitude, position.longitude);

          await presensi(position, address, distance);

          Get.snackbar("Berhasil", "Kamu telah berhasil absen");
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
        }
        // print('SELESAI');
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime dateNow = DateTime.now();
    String todayDocId = DateFormat.yMd().format(dateNow).replaceAll("/", "-");

    String statDistance = "Di luar area";
    if (distance <= 200) {
      statDistance = "Di dalam area";
    }

    if (snapPresence.docs.length == 0) {
      // belum pernah absen dan set absen masuk
      await colPresence.doc(todayDocId).set({
        "date": dateNow.toIso8601String(),
        "masuk": {
          "date": dateNow.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": statDistance,
          "distance": distance,
        }
      });
    } else {
      // sudah pernah absesn, cek hari ini sudah absen masuk /keluar belum..?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      if (todayDoc.exists == true) {
        // absen masuk dan keluar
        Map<String, dynamic>? dataPresenceToday = await todayDoc.data();

        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar("Sukses", "Kamu telah absen masuk dan keluar.");
        } else {
          // absen keluar
          await colPresence.doc(todayDocId).update({
            "keluar": {
              "date": dateNow.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": statDistance,
              "distance": distance,
            }
          });
        }
      } else {
        // abesn masuk
        await colPresence.doc(todayDocId).set({
          "date": dateNow.toIso8601String(),
          "masuk": {
            "date": dateNow.toIso8601String(),
            "lat": position.latitude,
            "long": position.longitude,
            "address": address,
            "status": statDistance,
            "distance": distance
          }
        });
      }
    }
  }

  Future<void> updatePosistion(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Layanan lokasi dinonaktifkan.",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin lokasi ditolak.",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      return {
        "message":
            "Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasi mendapatkan posisi device",
      "error": false,
    };
  }
}
