import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dashboard_screen.dart';
import '../model/my_user.dart';
import '../model/percentage_series.dart';
import '../utils/check_internet_status.dart';


List<int> stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
MyUser user = MyUser(0, 0, 0, "Other", 0, 1.0, 0, 0, new GeoPoint(0.0, 0.0), new GeoPoint(0.0, 0.0), 0, stats, stats, 0, stats);

getUserData() async {
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((
      result) {
    user.caloriesStatistics = result.data()['caloriesStatistics'].cast<int>();
    user.drinkStatistics = result.data()['drinkStatistics'].cast<int>();
    user.burnedStatistics = result.data()['burnedStatistics'].cast<int>();
  });
}

Future<List<List<PercentageSeries>>> loadData() async {
  await getUserData();

  List<PercentageSeries> caloriesList = [];
  for (int i = 0; i < user.caloriesStatistics.length; i++) {
    caloriesList.add(new PercentageSeries(day: user.caloriesStatistics.length - i, percentage: user.caloriesStatistics[i], color: charts.ColorUtil.fromDartColor(Colors.amber)));
  }

  List<PercentageSeries> drinkList = [];
  for (int i = 0; i < user.drinkStatistics.length; i++) {
    drinkList.add(new PercentageSeries(day: user.drinkStatistics.length - i, percentage: user.drinkStatistics[i], color: charts.ColorUtil.fromDartColor(Colors.blueAccent)));
  }

  List<PercentageSeries> burnedList = [];
  for (int i = 0; i < user.burnedStatistics.length; i++) {
    burnedList.add(new PercentageSeries(day: user.burnedStatistics.length - i, percentage: user.burnedStatistics[i], color: charts.ColorUtil.fromDartColor(Colors.redAccent)));
  }

  List<List<PercentageSeries>> result = [];
  result.add(caloriesList);
  result.add(drinkList);
  result.add(burnedList);

  return result;
}


Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Information about charts'),
    content: Container(
      height: 180,
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'What axes of chart mean:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("The horizontal axis shows the days "),
            Text("(number means how many days ago it was)."),
            Text(""),
            Text("The vertical axis shows how many percent You have achieved on that day."),
            Text(""),
            Text("Graphs are updated once per day."),
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


class StatisticsScreen extends StatefulWidget {
  static const routeName = '/statistics';

  StatisticsScreen({Key key}) : super(key: key);

  @override
  StatisticsScreenState createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoaded = false;
  List<PercentageSeries> caloriesData;
  List<PercentageSeries> drinkData;
  List<PercentageSeries> burnedData;

  @override
  void initState() {
    super.initState();
    CheckInternetStatus().checkConnection(context);
    initData();
  }

  @override
  void dispose() {
    CheckInternetStatus().listener.cancel();
    super.dispose();
  }

  Future<void> initData() async {
    await loadData().then((val) => setState(() {
      if (val != null) {
        caloriesData = val[0];
        drinkData = val[1];
        burnedData = val[2];
        isLoaded = true;
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PercentageSeries, String>> caloriesSeries =
        [
          charts.Series(
            id: "Percent",
            data: caloriesData,
            domainFn: (PercentageSeries series, _) => series.day.toString(),
            measureFn: (PercentageSeries series, _) => series.percentage,
            colorFn: (PercentageSeries series, _) => series.color,
          )
        ];
    List<charts.Series<PercentageSeries, String>> drinkSeries =
    [
      charts.Series(
        id: "Percent",
        data: drinkData,
        domainFn: (PercentageSeries series, _) => series.day.toString(),
        measureFn: (PercentageSeries series, _) => series.percentage,
        colorFn: (PercentageSeries series, _) => series.color,
      )
    ];
    List<charts.Series<PercentageSeries, String>> burnedSeries =
    [
      charts.Series(
        id: "Percent",
        data: burnedData,
        domainFn: (PercentageSeries series, _) => series.day.toString(),
        measureFn: (PercentageSeries series, _) => series.percentage,
        colorFn: (PercentageSeries series, _) => series.color,
      )
    ];

    return !isLoaded ? SizedBox() : Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Graph of Your achieved kilocalories goals from last 14 days:",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Container(
                  height: 430,
                  width: 300,
                  child: charts.BarChart(caloriesSeries, animate: true),
                ),
                SizedBox(
                  width: 20.0,
                  height: 50.0,
                ),
                Text(
                  "Graph of Your achieved water goals from last 14 days:",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Container(
                  height: 430,
                  width: 300,
                  child: charts.BarChart(drinkSeries, animate: true),
                ),
                SizedBox(
                  width: 20.0,
                  height: 50.0,
                ),
                Text(
                  "Graph of Your achieved burned kilocalories goals from last 14 days:",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Container(
                  height: 430,
                  width: 300,
                  child: charts.BarChart(burnedSeries, animate: true),
                ),
              ],
          ),
        ),
      ),
    );
  }
}