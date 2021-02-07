import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'edit_user_screen.dart';
import '../model/my_user.dart';


class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileboard';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  static List<int> stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  MyUser user = MyUser(0, 0, 0, "Other", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0, stats, stats, 0, stats);
  TextEditingController _userWeightController = TextEditingController();
  TextEditingController _userHeightController = TextEditingController();
  TextEditingController _userAgeController = TextEditingController();
  TextEditingController _userSexController = TextEditingController();
  TextEditingController _userActivityController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Information about activity'),
      content: Container(
        height: 230,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'What activity means:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's Your type of lifestyle:"),
              Text("1.0 - lying or sedentary lifestyle, lack "),
              Text("         of physical activity"),
              Text("1.2 - sedentary work, low-level "),
              Text("         physical activity"),
              Text("1.4 - non-physical work, training "),
              Text("         twice a week"),
              Text("1.6 - light physical work, training 3-4 "),
              Text("         times a week"),
              Text("1.8 - physical work, training 5 times "),
              Text("         a week"),
              Text("2.0 - hard physical work, daily "),
              Text("         training "),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
          )
        ],
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
              future: getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    return Column(
      children: <Widget>[
        FutureBuilder(
            future: getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _userAgeController.text = user.age.toString();
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Age : ${_userAgeController.text} years",
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
                _userHeightController.text = user.height.toString();
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Height : ${_userHeightController.text} cm",
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
                _userWeightController.text = user.weight.toString();
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Weight : ${_userWeightController.text} kg",
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
                _userSexController.text = user.sex;
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sex : ${_userSexController.text}",
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
                _userActivityController.text = user.activity.toString();
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Activity : ${_userActivityController.text}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        SizedBox(
          width: 20.0,
          height: 50.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.4,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: MaterialButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(),
                  ),
                );
              },
              child: Text("Edit user")),
        ),
      ],
    );
  }
}