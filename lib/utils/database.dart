import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid;
  Database({this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  
  Future updateUserInfo(int weight, int height, int age, int points, String sex, double activity, int calories, int drink, GeoPoint geoBefore,
      GeoPoint geoNow, int day, List<int> caloriesStatistics, List<int> drinkStatistics, int burned, List<int> burnedStatistics) async {
    return await usersCollection.doc(uid).set({
      'weight': weight,
      'height': height,
      'age': age,
      'points': points,
      'sex': sex,
      'activity': activity,
      'calories': calories,
      'drink': drink,
      'geoBefore': geoBefore,
      'geoNow': geoNow,
      'day': day,
      'caloriesStatistics': caloriesStatistics,
      'drinkStatistics': drinkStatistics,
      'burned': burned,
      'burnedStatistics': burnedStatistics,
    }).then((value) => print("User updated")).catchError((error) => print("Failed to update user: $error"));
  }

  Future updateUserWeight(int weight) async {
    return await usersCollection.doc(uid).update({
      'weight': weight,
    }).then((value) => print("Weight changed")).catchError((error) => print("Failed to change weight: $error"));
  }

  Future updateUserHeight(int height) async {
    return await usersCollection.doc(uid).update({
      'height': height,
    }).then((value) => print("Height changed")).catchError((error) => print("Failed to change height: $error"));
  }

  Future updateUserAge(int age) async {
    return await usersCollection.doc(uid).update({
      'age': age,
    }).then((value) => print("Age changed")).catchError((error) => print("Failed to change age: $error"));
  }

  Future updateUserPoints(int points) async {
    return await usersCollection.doc(uid).update({
      'points': points,
    }).then((value) => print("Points changed")).catchError((error) => print("Failed to change points: $error"));
  }

  Future incrementUserPoints(int points) async {
    return await usersCollection.doc(uid).update({
      'points': FieldValue.increment(points),
    }).then((value) => print("Points changed")).catchError((error) => print("Failed to change points: $error"));
  }

  Future updateUserSex(String sex) async {
    return await usersCollection.doc(uid).update({
      'sex': sex,
    }).then((value) => print("Sex changed")).catchError((error) => print("Failed to change sex: $error"));
  }

  Future updateUserActivity(double activity) async {
    return await usersCollection.doc(uid).update({
      'activity': activity,
    }).then((value) => print("Activity changed")).catchError((error) => print("Failed to change activity: $error"));
  }

  Future updateUserCalories(int calories) async {
    return await usersCollection.doc(uid).update({
      'calories': calories,
    }).then((value) => print("Calories changed")).catchError((error) => print("Failed to change calories: $error"));
  }

  Future incrementUserCalories(int calories) async {
    return await usersCollection.doc(uid).update({
      'calories': FieldValue.increment(calories),
    }).then((value) => print("Calories changed")).catchError((error) => print("Failed to change calories: $error"));
  }

  Future updateUserDrink(int drink) async {
    return await usersCollection.doc(uid).update({
      'drink': drink,
    }).then((value) => print("Drink changed")).catchError((error) => print("Failed to change drink: $error"));
  }

  Future incrementUserDrink(int drink) async {
    return await usersCollection.doc(uid).update({
      'drink': FieldValue.increment(drink),
    }).then((value) => print("Drink changed")).catchError((error) => print("Failed to change drink: $error"));
  }

  Future updateUserGeoPoints(GeoPoint geoBefore, GeoPoint geoNow) async {
    await usersCollection.doc(uid).update({
      'geoBefore': geoBefore,
    }).then((value) => print("Geopoint before changed")).catchError((error) => print("Failed to change geopoint before: $error"));
    return await usersCollection.doc(uid).update({
      'geoNow': geoNow,
    }).then((value) => print("Geopoint now changed")).catchError((error) => print("Failed to change geopoint now: $error"));
  }

  Future updateUserDay(int day) async {
    return await usersCollection.doc(uid).update({
      'day': day,
    }).then((value) => print("Day changed")).catchError((error) => print("Failed to change day: $error"));
  }

  Future updateUserCaloriesStatistics(List<int> caloriesStatistics) async {
    return await usersCollection.doc(uid).update({
      'caloriesStatistics': caloriesStatistics,
    }).then((value) => print("Calories statistics changed")).catchError((error) => print("Failed to change calories statistics: $error"));
  }

  Future updateUserDrinkStatistics(List<int> drinkStatistics) async {
    return await usersCollection.doc(uid).update({
      'drinkStatistics': drinkStatistics,
    }).then((value) => print("Drink statistics changed")).catchError((error) => print("Failed to change drink statistics: $error"));
  }

  Future updateUserBurned(int burned) async {
    return await usersCollection.doc(uid).update({
      'burned': burned,
    }).then((value) => print("Burned changed")).catchError((error) => print("Failed to change burned: $error"));
  }

  Future incrementUserBurned(int burned) async {
    return await usersCollection.doc(uid).update({
      'burned': FieldValue.increment(burned),
    }).then((value) => print("Burned changed")).catchError((error) => print("Failed to change burned: $error"));
  }

  Future updateUserBurnedStatistics(List<int> burnedStatistics) async {
    return await usersCollection.doc(uid).update({
      'burnedStatistics': burnedStatistics,
    }).then((value) => print("Burned statistics changed")).catchError((error) => print("Failed to change burned statistics: $error"));
  }
}