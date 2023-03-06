import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<String> uploadData(Position? cPosition, Timestamp dt) async {
  String data = '';
  try {
    await FirebaseFirestore.instance.collection('devices').add({
      'latitude': cPosition?.latitude.toStringAsFixed(3),
      'longitude': cPosition?.longitude.toStringAsFixed(3),
      'time': dt,
      'data': 'You have receieved Data',
    });
    print('done');
    data = 'Done';
  } catch (e) {
    data = e.toString();
  }

  return data;
}
