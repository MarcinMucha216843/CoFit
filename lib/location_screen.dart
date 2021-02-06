import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dashboard_screen.dart';
import 'my_user.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = '/location';

  LocationScreen({Key key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static List<int> stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  MyUser user = MyUser(0, 0, 0, "Man", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0, stats, stats);
  Position _position;
  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _positionStream.cancel();
  }

  getProfileData() async {
    final uid = await FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((
        result) {
      user.weight = result.data()['weight'];
      user.height = result.data()['height'];
      user.sex = result.data()['sex'];
      user.age = result.data()['age'];
      user.points = result.data()['points'];
      user.activity = result.data()['activity'];
      user.calories = result.data()['calories'];
      user.drink = result.data()['drink'];
      user.geoBefore = result.data()['geoBefore'];
      user.geoNow = result.data()['geoNow'];
      user.day = result.data()['day'];
    });
  }

  Future getPosition() async {
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator().getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _position = position;
      });
    });
    return _position;
  }

  Future getCurrentPosition() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _position = position;
    print(_position);

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
      'geoBefore': user.geoNow,
    });
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
      'geoNow': GeoPoint(_position.latitude, _position.longitude),
    });

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            BackButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ),
                );
              },
            ),
            Text(
              'CoFit',
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: getProfileData(),
              builder: (context, snapshot) {
                return displayInformation(context, snapshot);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayInformation(context, snapshot) {
    return Column(
      children: <Widget>[
        FutureBuilder(
            future: getCurrentPosition(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Location : ${_position?.latitude?? '-'}, ${_position?.longitude?? '-'}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        FutureBuilder(
            future: getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "GeoBefore : ${user.geoBefore.latitude}, ${user.geoBefore.longitude}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        FutureBuilder(
            future: getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "GeoNow : ${user.geoNow.latitude}, ${user.geoNow.longitude}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ],
    );
  }
}