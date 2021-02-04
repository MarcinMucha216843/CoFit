import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'countdown_timer.dart';
import 'dashboard_screen.dart';
import 'dart:math';

String title = "error";
String link = "error";
var rng = new Random();
int counter = 0;

rand() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int number = rng.nextInt(11) + 1;
  int visibility = prefs.getInt('visibility');

  while (prefs.getInt(number.toString()) != null) {
    print(number);
    number = rng.nextInt(11) + 1;
  }

  counter += 1;
  prefs.setInt('counter', counter);
  visibility += 1;
  prefs.setInt('visibility', visibility);

  if(visibility > 4) {
    visibility = 0;
  }

  if (prefs.getInt('counter') > 9) {
    prefs.remove('1');
    prefs.remove('2');
    prefs.remove('3');
    prefs.remove('4');
    prefs.remove('5');
    prefs.remove('6');
    prefs.remove('7');
    prefs.remove('8');
    prefs.remove('9');
    prefs.remove('10');
    prefs.remove('11');
    prefs.remove('counter');
    counter = 0;
  }

  switch(number){
    case 1: {title = "High knees"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/high%20knees.png?alt=media&token=fe32e9a8-4278-4ca2-96b1-1fffa9af8a19";}
    prefs.setInt('1', number);
    print(title);
    print(link);
    break;

    case 2: {title = "Jumping jacks"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/jumping%20jacks.png?alt=media&token=c6f3152c-f84a-4c22-8d9e-cd97c4c02e08";}
    prefs.setInt('2', number);
    print(title);
    print(link);
    break;

    case 3: {title = "Knees pull-ins"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/knee%20pull.png?alt=media&token=dfb35497-1e35-44be-8418-fc0b65f71655";}
    prefs.setInt('3', number);
    print(title);
    print(link);
    break;

    case 4: {title = "Leg raises"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/leg%20rises.png?alt=media&token=36fc413e-e096-4e87-834c-816530d715a7";}
    prefs.setInt('4', number);
    print(title);
    print(link);
    break;

    case 5: {title = "Lunge"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/lunge.png?alt=media&token=bd44a59a-b956-40d0-91e9-8c5372586d7e";}
    prefs.setInt('5', number);
    print(title);
    print(link);
    break;

    case 6: {title = "Mountain climbers"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/mountain%20climbers.png?alt=media&token=bc351771-f68d-432f-b71f-c435c76f3f9f";}
    prefs.setInt('6', number);
    print(title);
    print(link);
    break;

    case 7: {title = "Pelvic scoop"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/pelvic%20scoopp.png?alt=media&token=735d387a-b571-4b33-ad0d-6a8ca5ad1c3c";}
    prefs.setInt('7', number);
    print(title);
    print(link);
    break;

    case 8: {title = "Push ups"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/push%20up.png?alt=media&token=de68663d-f4df-4caa-a07b-10260c6123d1";}
    prefs.setInt('8', number);
    print(title);
    print(link);
    break;

    case 9: {title = "Squats"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/squat.png?alt=media&token=f13764ff-7cbf-4c76-b031-5269e5ac2b31";}
    prefs.setInt('9', number);
    print(title);
    print(link);
    break;

    case 10: {title = "Toe crunches"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/toe%20crunches.png?alt=media&token=56d41144-2831-41a4-8c81-060c31712489";}
    prefs.setInt('10', number);
    print(title);
    print(link);
    break;

    case 11: {title = "Wall sit"; link = "https://firebasestorage.googleapis.com/v0/b/degree20.appspot.com/o/wall%20sit.png?alt=media&token=e6f23e5f-f5f0-45ee-8f7c-bdf4d8d0acd4";}
    prefs.setInt('11', number);
    print(title);
    print(link);
    break;

    default: { print("Invalid choice"); }
    print(title);
    print(link);
    break;
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Information about excercises'),
    content: Container(
      height: 230,
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Excercises:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("During each exercise, try to repeat what is shown in the picture as many times as possible."),
            Text("You have a minute to do this."),
            Text("You can do maximally 5 exercises in a row."),
            SizedBox(
              width: 20.0,
              height: 20.0,
            ),
            Text("Press 'Start excercise' button first and then 'Play' button to complete the excercise."),
            Text("You are able to cancel the exercise while it's in progress."),
            Text("Each started excercise gives you a point."),
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

class ExcerciseScreen extends StatefulWidget {
  static const routeName = '/excercise';

  ExcerciseScreen({Key key}) : super(key: key);

  @override
  _ExcerciseScreenState createState() => _ExcerciseScreenState();
}

class _ExcerciseScreenState extends State<ExcerciseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            BackButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ),
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('1');
                prefs.remove('2');
                prefs.remove('3');
                prefs.remove('4');
                prefs.remove('5');
                prefs.remove('6');
                prefs.remove('7');
                prefs.remove('8');
                prefs.remove('9');
                prefs.remove('10');
                prefs.remove('11');
                prefs.remove('counter');
                prefs.remove('visibility');
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20.0,
              height: 10.0,
            ),
            FutureBuilder(
              future: rand(),
              builder: (context, snapshot) {
                return displayInformation(context, snapshot);
              },
            ),
            SizedBox(
              width: 20.0,
              height: 30.0,
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
                        builder: (context) => CountDownTimer(),
                      ),
                    );
                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
                      'points': FieldValue.increment(1),
                    });
                  },
                  child: Text("Start excercise")),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayInformation(context, snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(link),
        ),
        Text(
            "${title}",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ],
    );
  }
}