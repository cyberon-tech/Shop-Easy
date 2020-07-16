import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shopeasy/screens/terms_policy.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/screens/about_page.dart';
import 'package:shopeasy/screens/help_screen.dart';
import 'package:shopeasy/screens/settings_page.dart';
import 'package:shopeasy/services/authservice.dart';
import 'package:shopeasy/widgets/category_widget.dart';

enum popUp { settings, terms, about }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final databaseReference = FirebaseDatabase.instance.reference();

  int appVersion = 1;

  Position _currentPosition;
  String _currentPlace;
  bool toggle = false;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentPlace = "${place.locality}";
        if (_currentPlace.isEmpty) {
          _currentPlace = "PIN-${place.postalCode}";
        }
      });
    } catch (e) {
      print(e);
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
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _showDialog1(title, text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.teal.shade700),
          ),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text('Exit'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            FlatButton(
              color: Colors.teal,
              child: Text('Update & Continue'),
              onPressed: () {
                StoreRedirect.redirect();
              },
            )
          ],
        );
      },
    );
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (result == ConnectivityResult.none) {
      _showDialog('No internet',
          "No connection found! \nPlease check your internet connection.");
    } else if (geolocationStatus == GeolocationStatus.disabled) {
      _showDialog('Location disabled', "Turn on location.");
    }
  }

  Future<void> checkAppVersion() async {
    int av;
    databaseReference.child("appVersion").once().then((DataSnapshot snapshot) {
      setState(() {
        av = snapshot.value;
        print(snapshot.value);
      });
      if (av != appVersion) {
        _showDialog1('New Version Available!',
            'Please, update Shop Easy App to new version to continue service');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAppVersion();
    _getCurrentLocation();
    _checkInternetConnectivity();
    if (toggle == false) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showDialog(
            'Alert', 'For better performance enable location(or GPS)!'),
      );
      setState(() {
        toggle = true;
      });
    }
  }

  _exit() {
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => _exit(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: AssetImage('assets/shopEasyIcon.png'),
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
            actions: <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.home,
//                color: Colors.blueGrey.shade800,
//                size: 40,
//              ),
//              onPressed: () {},
//            ),
              PopupMenuButton(
                  onSelected: (value) {
                    if (value == popUp.settings) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    } else if (value == popUp.about) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => About()),
                      );
                    } else if (value == popUp.terms) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TermsPolicy()),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: popUp.settings,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Settings'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: popUp.about,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.help,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('About'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: popUp.terms,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.enhanced_encryption,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Terms & Policy'),
                          ],
                        ),
                      ),
                    ];
                  })
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('hp1'),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.black54,
                                size: 15,
                              ),
                              _currentPlace == null
                                  ? Container(
                                      width: 50,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _currentPlace,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                splashColor: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        'assets/addShop.png',
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('hp2'),
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
//                                      fontFamily: 'Righteous',
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AuthService().handleAuth(),
                                    ),
                                  );
                                },
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
//                  SizedBox(
//                    width: 20,
//                  ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Categories(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(),
                ),
              );
            },
            tooltip: AppLocalizations.of(context).translate('hp4'),
            child: Icon(
              Icons.help_outline,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

//                                Stack(
//                                  alignment: AlignmentDirectional.center,
//                                  children: <Widget>[
//                                    Positioned(
//                                      child: Icon(
//                                        Icons.shopping_cart,
//                                        size: 30,
//                                        color: Colors.teal.shade700,
//                                      ),
//                                      bottom: 10,
//                                      right: 10,
//                                    ),
//                                    Positioned(
//                                      child: Icon(
//                                        Icons.shopping_cart,
//                                        size: 30,
//                                        color: Colors.blue.shade900,
//                                      ),
//                                      top: 11,
//                                      left: 10,
//                                    ),
//                                  ],
//                                )
