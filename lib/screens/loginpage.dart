import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shopeasy/helpers/app_localization.dart';

import '../services/authservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool toggle = false;
  bool tg1 = false;
  bool tg2 = false;

  final formKey = new GlobalKey<FormState>();

  String phoneNo = "", verificationId, smsCode;

  bool codeSent = false;

  final int regCode = 91;

  void _savePage() {
    final isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState.save();
    if (phoneNo.length == 13) {
      codeSent
          ? AuthService().signInWithOTP(smsCode, verificationId)
          : verifyPhone(phoneNo);
    }
  }

  _showDialog(title, text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              color: Colors.teal,
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //Loading counter value on start
  Future<String> _setPhoneNo(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('mob', value);
    });
  }

  Future<String> _setName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('name', value);
      print(prefs.getString('name'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(AppLocalizations.of(context).translate('lg1'))),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.4),
                    blurRadius: 5.0,
                    // has the effect of softening the shadow
                    spreadRadius: 10.0,
                    // has the effect of extending the shadow
                    offset: Offset(
                      4, // horizontal, move right 10
                      7, // vertical, move down 10
                    ),
                  )
                ],
              ),
              margin:
                  EdgeInsets.only(top: 100, right: 20, left: 20, bottom: 20),
              padding: EdgeInsets.all(5),
              // color: Colors.teal.withOpacity(.5),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate('lg2'),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('lg3'),
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('lg4')),
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('lg6');
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              if (val.isEmpty) {
                                tg1 = false;
                                return 'Please enter your name.';
                              }
                              tg1 = true;
                              return null;
                              this.phoneNo = val;
                              _setName(val);
                            });
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: TextFormField(
                            initialValue: '+$regCode',
                            keyboardType: TextInputType.phone,
                            maxLength: 13,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('lg5')),
                            onChanged: (val) {
                              setState(() {
                                if (val.length == 13) {
                                  tg2 = true;
                                  this.phoneNo = val;
                                } else {
                                  codeSent = false;
                                  tg2 = false;
                                }
                                _setPhoneNo(val);
                              });
                            },
                          )),
                      codeSent
                          ? Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('lg10')),
                                onChanged: (val) {
                                  setState(() {
                                    this.smsCode = val;
                                  });
                                },
                              ))
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: RaisedButton(
                              color: toggle
                                  ? codeSent
                                      ? Colors.green
                                      : tg2
                                          ? Colors.white
                                          : Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor,
                              child: Center(
                                  child: codeSent
                                      ? Text(
                                          'Login',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          'Verify',
                                          style: TextStyle(color: Colors.black),
                                        )),
                              onPressed: () {
                                final isValid = formKey.currentState.validate();
                                if (!isValid) {
                                  return;
                                }
                                setState(() {
                                  if (tg1 == true && tg2 == true) {
                                    toggle = true;
                                  } else {
                                    toggle = false;
                                  }
                                });
                                _savePage();
                              })),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    PhoneVerificationFailed verificationfailed = (AuthException authException) {
      print('${authException.message}');
      _showDialog('Notification',
          'Login limit of your account is reached max\nUse another account or Try again tommorow');
      setState(() {
        codeSent = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 20),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
