import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.navigate_before,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: AssetImage('assets/shopEasyIcon.png'),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Shop Easy',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'RussoOne',
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        body: InkWell(
          splashColor: toggle == true ? Colors.blue : Colors.amber,
          onTap: () {
            setState(() {
              toggle = !toggle;
            });
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/abt.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
