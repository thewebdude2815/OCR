import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              //   Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              //   Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              //   const SizedBox(height: 32),
              //   ElevatedButton(
              //     onPressed: () async {
              //       if (_currentPosition?.latitude == null) {
              //       } else {}
              //     },
              //     child: const Text("Upload"),
            ],
          ),
        ),
      ),
    );
  }
}
