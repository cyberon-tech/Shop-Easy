import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPolicy extends StatefulWidget {
  @override
  _TermsPolicyState createState() => _TermsPolicyState();
}

class _TermsPolicyState extends State<TermsPolicy> {
  _launchURL() async {
    const url = "http://www.arkroot.com/privacy_policy.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Container(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Terms & Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "For more info on Terms And Policy Click the button below",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        color: Colors.blue,
                        child: Text(
                          "Know More",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _launchURL();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
