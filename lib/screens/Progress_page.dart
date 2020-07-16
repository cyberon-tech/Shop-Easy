import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/screens/first_app.dart';

import 'home_page.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  bool first = false;
  void _getFirst() async {
    var prefs = await SharedPreferences.getInstance();
    bool f = await prefs.getBool('first') ?? false;
    setState(() {
      first = f;
      if (first == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
//        Navigator.pop();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirstApp(),
          ),
        );
//        Navigator.pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getFirst();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
