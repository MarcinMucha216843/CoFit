import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  int age;
  int weight;
  int height;
  String sex;
  int points;
  double activity;
  int calories;
  int drink;
  GeoPoint geoBefore;
  GeoPoint geoNow;
  int day;

  MyUser(this.age, this.weight, this.height, this.sex, this.points, this.activity, this.calories, this.drink, this.geoBefore, this.geoNow, this.day);

  Map<String, dynamic> toJson() => {
    'age': age,
    'weight': weight,
    'height': height,
    'sex': sex,
    'points': points,
    'activity': activity,
    'calories': calories,
    'drink': drink,
    'geoBefore': geoBefore,
    'geoNow': geoNow,
    'day': day,
  };
}