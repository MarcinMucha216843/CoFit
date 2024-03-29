import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../utils/database.dart';
import '../model/my_user.dart';
import '../utils/check_internet_status.dart';


class GoalsScreen extends StatefulWidget {
  static const routeName = '/goalsboard';

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}


class _GoalsScreenState extends State<GoalsScreen> {
  static List<int> stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  MyUser user = MyUser(0, 0, 0, "Other", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0, stats, stats, 0, stats);

  @override
  void initState() {
    super.initState();
    CheckInternetStatus().checkConnection(context);
  }

  @override
  void dispose() {
    CheckInternetStatus().listener.cancel();
    super.dispose();
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
      user.day = result.data()['day'];
      user.burned = result.data()['burned'];
    });
  }

  Future<bool> _updateCaloriesDrinkBurned() async {
    try {
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserCalories(0);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserDrink(0);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserBurned(0);

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  double calculateCalories() {
    int weight = user.weight;
    int height = user.height;
    int age = user.age;
    String sex = user.sex;
    double activity = user.activity;
    double function = 0;

    if (sex == "Man") {
      function = 66.5 + (13.7 * weight) + (5 * height) - (6.8 * age);
    }
    else {
      function =  665 + (9.6 * weight) + (1.85 * height) - (4.7 * age);
    }

    return (function * activity).floorToDouble();
  }

  double caloriesPercentage(){
    double percentage = double.parse(((user.calories/calculateCalories())*100).toStringAsFixed(1));
    if (percentage > 100){
      percentage = 100;
    }
    
    return percentage;
  }

  int calculateDrink(){
    int weight = user.weight;
    int function = 0;
    function = weight * 32;

    return function;
  }

  double drinkPercentage(){
    double percentage = double.parse(((user.drink/calculateDrink())*100).toStringAsFixed(1));
    if (percentage > 100){
      percentage = 100;
    }
    
    return percentage;
  }

  double calculateBurned() {
    int weight = user.weight;
    String sex = user.sex;
    double activity = user.activity;
    double function = 0;

    if (sex == "Man") {
      function = 1.2 * (0.2 * weight) * 5;
    }
    else {
      function = (0.2 * weight) * 5;
    }

    return (function * activity).floorToDouble();
  }

  double burnedPercentage(){
    double percentage = double.parse(((user.burned/calculateBurned())*100).toStringAsFixed(1));
    if (percentage > 100){
      percentage = 100;
    }

    return percentage;
  }
  
  Color setColor(double percentage) {
    if (percentage < 40) {
      return Colors.red;
    }
    else if (percentage < 80) {
      return Colors.amber;
    }
    else {
      return Colors.lightGreen[900];
    }
  }

  double calculateBMI() {
    int weight = user.weight;
    double height = user.height / 100;
    double bmi = weight / (height * height);

    return bmi;
  }

  Color setBmiColor(double bmi) {
    if (bmi < 16.99) {
      return Colors.red;
    }
    else if (bmi < 18.49) {
      return Colors.amber;
    }
    else if (bmi < 24.99) {
      return Colors.lightGreen[900];
    }
    else if (bmi < 29.99) {
      return Colors.amber;
    }
    else {
      return Colors.red;
    }
  }

  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Information about goals'),
      content: Container(
        height: 230,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Points:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's the number of points You collected."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'BMI:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's Your Body Mass Index."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text("Values and categories:"),
              Text("BMI < 15     - very severely underweight"),
              Text("BMI < 16     - severely underweight"),
              Text("BMI < 18.5  - underweight"),
              Text("BMI < 25     - normal (healthy weight)"),
              Text("BMI < 30     - overweight"),
              Text("BMI < 35     - obese class I (moderately "),
              Text("                       obese)"),
              Text("BMI < 40     - obese class II (severely "),
              Text("                       obese)"),
              Text("BMI > 40     - obese class III (very "),
              Text("                       severely obese)"),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Your caloric intake:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's the amount of kilocalories (kcal) You consumed today."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Daily caloric requirement:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's Your recommended amount of kilocalories (kcal) per day."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Your water intake:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's the amount of water (ml) You drank today."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Daily water requirement:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's Your recommended amount of water (ml) per day."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Your burned kilocalories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's the amount of kilocalories (kcal) You burned today."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Daily burned kilocalories requirement:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("It's Your recommended amount of burned kilocalories (kcal) per day."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Delete button:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("You can reset 'Your caloric intake', 'Your water consumption' and 'Your burned kilocalories' values on Your own."),
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

  Widget _buildConfirmationDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text("Confirmation"),
      content: Container(
        height: 80,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Are You sure You want to reset "),
              Text("'Your caloric intake', 'Your water consumption' and 'Your burned kilocalories' values?")
            ]
          )
        )
      ),
      actions: [
        FlatButton(
          child: Text("No, cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes, continue"),
          onPressed: () async {
            _updateCaloriesDrinkBurned();
            setState(() {});
            Navigator.of(context).pop();
          },
        )
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
              Icons.delete ,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildConfirmationDialog(context),
              );
            },
          ),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return displayInformation(context, snapshot);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayInformation(context, snapshot) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 20.0,
          height: 30.0,
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
                        "Your points : ${user.points} points",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Your BMI : ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "${calculateBMI().toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 20, color: setBmiColor(calculateBMI()), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your caloric intake : ${user.calories} kcal",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Daily caloric requirement : ${calculateCalories().toInt()} kcal",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Achieved percentage : ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "${caloriesPercentage()}%",
                            style: TextStyle(fontSize: 20, color: setColor(caloriesPercentage()), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your water consumption : ${user.drink} ml",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Daily water requirement : ${calculateDrink()} ml",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Achieved percentage : ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "${drinkPercentage()}%",
                            style: TextStyle(fontSize: 20, color: setColor(drinkPercentage()), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your burned kilocalories : ${user.burned} kcal",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Daily burned kcal requirement : ${calculateBurned().toInt()} kcal",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Achieved percentage : ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            "${burnedPercentage()}%",
                            style: TextStyle(fontSize: 20, color: setColor(burnedPercentage()), fontWeight: FontWeight.bold),
                          ),
                        ],
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