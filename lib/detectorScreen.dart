// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gyrosensor/checkNearbyPeople.dart';
import 'package:gyrosensor/firestore_functions/uploadData.dart';
import 'package:gyrosensor/main.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DetectorScreen extends StatefulWidget {
  @override
  _DetectorScreenState createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  double x = 0, y = 0, z = 0;
  String direction = "none";
  List<String> listToCheckMovement = [];
  bool isLoading = false;
  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) async {
      if (event.z > 0) {
        if (listToCheckMovement.contains("up")) {
        } else {
          print("up");
          setState(() {
            listToCheckMovement.add("up");
          });
        }
      } else if (event.z < 0) {
        if (listToCheckMovement.contains("down")) {
        } else {
          setState(() {
            listToCheckMovement.add("down");
            isLoading = true;
          });
          print(currentPosition?.longitude);
          if (currentPosition?.latitude == null) {
          } else {
            Timestamp dtData = Timestamp.now();
            String dataReceived = await uploadData(currentPosition, dtData);
            if (dataReceived == 'Done') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return CheckNearbyPeople(
                  dt: dtData,
                  longitude: (currentPosition?.longitude.toDouble())!,
                  latitude: (currentPosition?.latitude.toDouble())!,
                );
              }));
            }
          }
        }
      } else {
        print('no motion detected');
      }
    });

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 8,
                  ),
                  Center(child: Text('Please Wait....'))
                ],
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Spacer(),
                    Lottie.asset('asset/phone.json', height: 250),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Move Your Phone In FRONT & BACK direction!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'You Will Be Redirected To The Connection Screen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
  }
}
