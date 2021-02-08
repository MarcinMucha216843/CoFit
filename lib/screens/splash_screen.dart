import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
          child: Center(
            child: Image.asset('assets/images/launcher.png')
          ),
        ),
    );
  }
}