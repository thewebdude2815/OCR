import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gyrosensor/checkNearbyPeople.dart';
import 'package:gyrosensor/detectorScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Position? currentPosition;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => currentPosition = position);
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  @override
  void initState() {
    _getCurrentPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetectorScreen(),
    );
  }
}
