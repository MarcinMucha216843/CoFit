import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'dashboard_screen.dart';
import '../utils/database.dart';


class AddCaloriesScreen extends StatefulWidget {
  static const routeName = '/addCalories';

  AddCaloriesScreen({Key key}) : super(key: key);

  @override
  _AddCaloriesState createState() => _AddCaloriesState();
}


class _AddCaloriesState extends State<AddCaloriesScreen> {
  TextEditingController _caloriesField = TextEditingController();

  Future<bool> _updateCalories(int calories) async {
    try {
      Database(uid: FirebaseAuth.instance.currentUser.uid).incrementUserCalories(calories);

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Information about kilocalories'),
      content: Container(
        height: 80,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Kilocalories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Entered value must be a positive number."),
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
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20.0,
                  height: 150.0,
                ),
                Text(
                  "How many kilocalories (kcal) do",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  "You want to add?",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  width: 20.0,
                  height: 50.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _caloriesField,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Kilocalories",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      bool shouldNavigate = false;
                      bool caloriesValid = RegExp(r"[1-9]{1}[0-9]{0,3}").hasMatch(_caloriesField.text);
                      if (_caloriesField.text.length <= 0) {
                        Flushbar(message: "Amount of kilocalories can't be empty", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (caloriesValid  == false){
                        Flushbar(message: "Amount of kilocalories must be a number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_caloriesField.text) <= 0){
                        Flushbar(message: "Amount of kilocalories must be a positive number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else {
                        shouldNavigate = await _updateCalories(int.parse(_caloriesField.text));
                      }
                      if (shouldNavigate) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                        Flushbar(message: "Kilocalories added succesfully", duration: Duration(seconds: 3),
                            icon: Icon(Icons.done_outline, size: 28, color: Colors.green.shade300)).show(context);
                      }
                    },
                    child: Text("Add kilocalories"),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
              ],
            )
        ),
      ),
    );
  }
}