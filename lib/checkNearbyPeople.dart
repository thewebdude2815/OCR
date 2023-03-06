import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gyrosensor/OCR/scanCamera.dart';
import 'package:intl/intl.dart';

class CheckNearbyPeople extends StatefulWidget {
  Timestamp dt;
  double longitude;
  double latitude;

  CheckNearbyPeople(
      {super.key,
      required this.dt,
      required this.latitude,
      required this.longitude});

  @override
  State<CheckNearbyPeople> createState() => _CheckNearbyPeopleState();
}

class _CheckNearbyPeopleState extends State<CheckNearbyPeople> {
  bool compareLongs(double a, double b) {
    // double a = 37.421;
    // double b = 37.401;
    bool valueToReturn;
    double tolerance = 0.010;

    if ((a - b).abs() < tolerance) {
      valueToReturn = true;
      print("a and b are close to each other.");
    } else {
      valueToReturn = false;
      print("a and b are not close to each other.");
    }
    return valueToReturn;
  }

  bool compareTime(Timestamp a, Timestamp b) {
    // double a = 37.421;
    // double b = 37.401;
    bool valueToReturn;
    const int tolerance = 10;
    final Duration difference = a.toDate().difference(b.toDate());
    int differenceInSecs = difference.inSeconds.abs();
    if (differenceInSecs <= tolerance) {
      valueToReturn = true;
      print("a and b are close to each other.");
    } else {
      valueToReturn = false;
      print("a and b are not close to each other.");
    }
    return valueToReturn;
  }

  // phoneA means my device
  // shouldn't be equal to A, decimal difference shouldn't be more than 0.010,
  // time difference shouldn't be more than 10 secs
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Connect'),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
          elevation: 10,
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('devices').snapshots(),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        bool value = compareLongs(
                            widget.latitude.toDouble(),
                            double.parse(snapshot.data!.docs[index]['latitude']
                                .toString()));
                        bool valueTime = compareTime(
                            widget.dt, snapshot.data!.docs[index]['time']);
                        final DateTime dateTime =
                            snapshot.data!.docs[index]['time'].toDate();
                        final dateString =
                            DateFormat.yMEd().add_jm().format(dateTime);
                        ;
                        return value && valueTime
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  style: ListTileStyle.list,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadiusDirectional.circular(12),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Latitude: ${snapshot.data!.docs[index]['latitude'].toString()}'),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                          'Longitude: ${snapshot.data!.docs[index]['longitude'].toString()}'),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text('Longitude: $dateString'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(snapshot
                                                  .data!.docs[index]['data'])));
                                    },
                                    icon: const Icon(
                                      Icons.call_missed_outgoing_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      });
                }
              }),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ScanCamera();
            }));
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
                child: Text(
              'Scan Card',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}
