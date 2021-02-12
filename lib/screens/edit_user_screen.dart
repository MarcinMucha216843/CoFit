import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'profile_screen.dart';
import '../utils/database.dart';
import '../utils/check_internet_status.dart';


class EditUserScreen extends StatefulWidget {
  static const routeName = '/edit';

  EditUserScreen({Key key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}


class _EditUserState extends State<EditUserScreen> {
  String dropdownValueSex = 'Other';
  double dropdownValueActivity = 1.0;

  TextEditingController _ageField = TextEditingController();
  TextEditingController _weightField = TextEditingController();
  TextEditingController _heightField = TextEditingController();

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

  Future<bool> _updateUser(int age, int weight, int height, String sex, double activity) async {
    try {
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserWeight(weight);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserHeight(height);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserAge(age);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserSex(sex);
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserActivity(activity);

      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Information about fields'),
      content: Container(
        height: 230,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Age:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Entered value must be a positive number."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Height:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Entered value must be a positive number."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Weight:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Entered value must be a positive number."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Sex:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Must be a value from the list."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Activity:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Must be a value from the list."),
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
                    builder: (context) => ProfileScreen(),
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: SizedBox(
                    width: 20.0,
                    height: 30.0,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _ageField,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Age",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _heightField,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Height",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _weightField,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Weight",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: DropdownButton<String>(
                    value: dropdownValueSex,
                    dropdownColor: Colors.deepPurple,
                    style: TextStyle(color: Colors.white),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValueSex = newValue;
                      });
                    },
                    items: <String>['Other', 'Man', 'Woman']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: DropdownButton<double>(
                    value: dropdownValueActivity,
                    dropdownColor: Colors.deepPurple,
                    style: TextStyle(color: Colors.white),
                    onChanged: (double newValue) {
                      setState(() {
                        dropdownValueActivity = newValue;
                      });
                    },
                    items: <double>[1.0, 1.2, 1.4, 1.6, 1.8, 2.0]
                        .map<DropdownMenuItem<double>>((double value) {
                      return DropdownMenuItem<double>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
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
                      bool shouldNavigate = false;
                      bool ageValid = RegExp(r"[1-9]{1}[0-9]{0,2}").hasMatch(_ageField.text);
                      bool heightValid = RegExp(r"[1-9]{1}[0-9]{0,2}").hasMatch(_heightField.text);
                      bool weightValid = RegExp(r"[1-9]{1}[0-9]{0,2}").hasMatch(_weightField.text);
                      if (_ageField.text.length <= 0) {
                        Flushbar(message: "Age can't be empty", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (ageValid == false){
                        Flushbar(message: "Age must be a number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_ageField.text) <= 0){
                        Flushbar(message: "Age must be a positive number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_ageField.text) > 140){
                        Flushbar(message: "Age is not valid. Please check the 'Info' button", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (_heightField.text.length <= 0) {
                        Flushbar(message: "Height can't be empty", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (heightValid == false){
                        Flushbar(message: "Height must be a number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_heightField.text) <= 0){
                        Flushbar(message: "Height must be a positive number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_heightField.text) > 270){
                        Flushbar(message: "Height is not valid. Please check the 'Info' button", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (_weightField.text.length <= 0) {
                        Flushbar(message: "Weight can't be empty", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (weightValid == false){
                        Flushbar(message: "Weight must be a number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_weightField.text) <= 0){
                        Flushbar(message: "Weight must be a positive number", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else if (int.parse(_weightField.text) > 400){
                        Flushbar(message: "Weight is not valid. Please check the 'Info' button", duration: Duration(seconds: 3),
                            icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                        shouldNavigate = false;
                      }
                      else {
                        shouldNavigate = await _updateUser(int.parse(_ageField.text), int.parse(_weightField.text),
                            int.parse(_heightField.text), dropdownValueSex, dropdownValueActivity);
                      }
                      if (shouldNavigate) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                        Flushbar(message: "Updated succesfully", duration: Duration(seconds: 3),
                            icon: Icon(Icons.done_outline, size: 28, color: Colors.green.shade300)).show(context);
                      }
                    },
                    child: Text("Update"),
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