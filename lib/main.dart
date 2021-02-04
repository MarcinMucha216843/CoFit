import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofit/register_screen.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_calories.dart';
import 'add_water.dart';
import 'dashboard_screen.dart';
import 'edit_user_screen.dart';
import 'excercise_screen.dart';
import 'goals_screen.dart';
import 'location_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'my_user.dart';
import 'profile_screen.dart';

var email;
bool move = true;

void showNotification(){
  showSilentNotification(FlutterLocalNotificationsPlugin(),
      title: "Let's excercise!", body: "You haven't moved for 3 hours", id: 30);
}

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}

Future showSilentNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      int id = 0,
    }) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);

Future _showNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required NotificationDetails type,
      int id = 0,
    }) =>
    notifications.show(id, title, body, type);


Future changeDay() async {
  MyUser user = new MyUser(0, 0, 0, "Man", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0);
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((
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

  DateTime today = DateTime.now();
  int day = today.day;

  if (user.day != day){
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
      'day': day,
    });
    managePoints();
  }
}

Future managePoints() async {
  MyUser user = new MyUser(0, 0, 0, "Man", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0);
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((
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

  int bonus = 0;
  double caloriesDaily = 0;
  if (user.sex == "Man") {
    caloriesDaily = (66.5 + (13.7 * user.weight) + (5 * user.height) - (6.8 * user.age))*user.activity;
  }
  else {
    caloriesDaily =  (665 + (9.6 * user.weight) + (1.85 * user.height) - (4.7 * user.age))*user.activity;
  }
  double caloriesPercentage = (user.calories/caloriesDaily)*100;
  if ((caloriesPercentage >= 100) & (caloriesPercentage < 120)){
    bonus += 1;
  }

  int drinkDaily = 0;
  drinkDaily = user.weight * 32;
  double drinkPercentage = (user.drink/drinkDaily)*100;
  if ((drinkPercentage >= 100) & (drinkPercentage < 120)){
    bonus += 1;
  }
  user.points += bonus;

  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
    'points': user.points,
  });
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
    'calories': 0,
  });
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
    'drink': 0,
  });
}

Future getCurrentPosition() async {
  MyUser user = new MyUser(0, 0, 0, "Man", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0);
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((
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
  Position _position;

  final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  _position = position;
  print(_position);

  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
    'geoBefore': user.geoNow,
  });
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
    'geoNow': GeoPoint(_position.latitude, _position.longitude),
  });

  return _position;
}

Future calculateDistance() async {
  MyUser user = new MyUser(0, 0, 0, "Man", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0);
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((
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

  var result = await Geolocator().distanceBetween(user.geoBefore.latitude, user.geoBefore.longitude, user.geoNow.latitude, user.geoNow.longitude);
  print(result);
  if (result < 20){
    print("Time to move");
    move = false;
    showNotification();
  }
  else {
    move = true;
  }
  print(move);
  return result;
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
      SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  print(email.toString());
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
  prefs.setInt('visibility', 0);

  runApp(MyApp());
  showNotification();

  changeDay();

  var cron = new Cron();
  cron.schedule(new Schedule.parse('30 1 * * *'), () async {
    await managePoints();
  });

  var cron2 = new Cron();
  cron2.schedule(new Schedule.parse('0 9,12,15,18,21 * * *'), () async {
    await getCurrentPosition();
    await calculateDistance();
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notifications = FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ExcerciseScreen()),
  );

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: email == null ? HomeScreen() : DashboardScreen(),
      title: 'CoFit',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.orange,
        cursorColor: Colors.orange,
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.orange,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        AddCaloriesScreen.routeName: (context) => AddCaloriesScreen(),
        AddDrinkScreen.routeName: (context) => AddDrinkScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        EditUserScreen.routeName: (context) => EditUserScreen(),
        GoalsScreen.routeName: (context) => GoalsScreen(),
        LocationScreen.routeName: (context) => LocationScreen(),
        ExcerciseScreen.routeName: (context) => ExcerciseScreen(),
      },
    );
  }
}