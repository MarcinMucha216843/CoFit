import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'home_screen.dart';
import '../utils/database.dart';
import '../utils/check_internet_status.dart';


class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}


class _RegisterState extends State<RegisterScreen> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _confirmPasswordField = TextEditingController();
  bool _isHidden = true;
  bool _isHidden2 = true;

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

  Future<bool> _registerUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.currentUser.sendEmailVerification();
      List<int> stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      Database(uid: FirebaseAuth.instance.currentUser.uid).updateUserInfo(0, 0, 0, 0, "Other", 1.0, 0, 0, GeoPoint(0.0, 0.0),
          GeoPoint(0.0, 0.0), 0, stats, stats, 0, stats);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Information about registration'),
      content: Container(
        height: 230,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("The email You provided must be unique. The same email cannot be used twice."),
              SizedBox(
                width: 20.0,
                height: 20.0,
              ),
              Text(
                'Password:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("The password You provide must be from 8 to 16 characters long. "
                  "It must contain at least one uppercase letter, one lowercase letter, one number and one special character (choose from @!%*#?&). "
                  "Both entered passwords must be the same."),
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
                    builder: (context) => HomeScreen(),
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
                  height: 100.0,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailField,
                  decoration: InputDecoration(
                    hintText: "something@email.com",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Email",
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
                  controller: _passwordField,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _confirmPasswordField,
                  obscureText: _isHidden2,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Confirm password",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    suffix: InkWell(
                      onTap: _togglePasswordView2,
                      child: Icon(
                        _isHidden2
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
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
                    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailField.text);
                    bool passwordValid = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$").hasMatch(_passwordField.text);
                    if (_emailField.text.length <= 0) {
                      Flushbar(message: "Email can't be empty", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (emailValid == false) {
                      Flushbar(message: "Email is not valid. Please check the 'Info' button", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (_passwordField.text.length <= 0) {
                      Flushbar(message: "Password can't be empty", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (passwordValid == false) {
                      Flushbar(message: "Password is not valid. Please check the 'Info' button", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (_passwordField.text.length < 8) {
                      Flushbar(message: "Password is too short", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (_passwordField.text.length > 16) {
                      Flushbar(message: "Password is too long", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (_confirmPasswordField.text.length <= 0) {
                      Flushbar(message: "Confirmed password can't be empty", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else if (_passwordField.text != _confirmPasswordField.text) {
                      Flushbar(message: "Passwords are not matching", duration: Duration(seconds: 3),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.red.shade300)).show(context);
                      shouldNavigate = false;
                    }
                    else {
                      shouldNavigate = await _registerUser(_emailField.text, _passwordField.text);
                    }
                    if (shouldNavigate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                      Flushbar(message: "After first login, please update Your profile", duration: Duration(seconds: 6),
                          icon: Icon(Icons.error_outline, size: 28, color: Colors.orange.shade300)).show(context);
                      Flushbar(message: "Succesfully registered. Please chcek Your email", duration: Duration(seconds: 3),
                          icon: Icon(Icons.done_outline, size: 28, color: Colors.green.shade300)).show(context);
                    }
                  },
                  child: Text("Register"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
            ],
          ),
        ),
      ),
    );
  }
}