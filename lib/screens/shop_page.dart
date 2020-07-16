import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopeasy/helpers/app_localization.dart';

import 'package:shopeasy/screens/settings_page.dart';
import 'package:shopeasy/services/authservice.dart';
import 'package:shopeasy/widgets/add_shop_widget.dart';
import 'package:shopeasy/widgets/shop_detail_widget.dart';
import 'about_page.dart';

enum popUp { sign_out, settings, about }

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String checkUninstall;
  String _currentDistrict;
  String _currentPlace;
  Position _currentPosition;
  bool hasShopData;
  String mob;
  Map<dynamic, dynamic> shop;

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

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (result == ConnectivityResult.none) {
      _showDialog('No internet',
          "No connection found! \nPlease check your internet connection.");
    }
  }

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
        _currentDistrict = "${place.subAdministrativeArea}";
        _getMob();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShop() async {
    databaseReference
        .child("$_currentDistrict/$_currentPlace/ID$mob")
        .onValue
        .listen((Event event) {
      setState(() {
//        _getLocation();
        shop = event.snapshot.value;
//        print(shop);
        if (shop == null) {
          hasShopData = false;
        } else {
          hasShopData = true;
        }
      });
    });
  }

  _getMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mob = await prefs.getString('mob');
    setState(() {});
    _getLocation();
//    getShop();
  }

  _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String place = await prefs.getString('place');
    setState(() {
      checkUninstall = place;
    });
    getShop();
  }

  @override
  void initState() {
    super.initState();
//    _setMob();
    _getCurrentLocation();
    _checkInternetConnectivity();
//    _getLocation();
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
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (value) {
                  if (value == popUp.sign_out) {
                    AuthService().signOut();
                  } else if (value == popUp.settings) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  } else if (value == popUp.about) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => About()),
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
                      value: popUp.sign_out,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.blueGrey.shade800,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
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
                  ];
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              hasShopData == null
                  ? Center(child: CircularProgressIndicator())
                  : Visibility(
                      visible: !hasShopData ?? false,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
//                          height: 70,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              splashColor: Colors.grey.withOpacity(0.2),
                              child: ListTile(
                                leading: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context).translate('sp1'),
                                  style: TextStyle(
                                    color: Colors.pink,
//                                    fontFamily: 'Righteous',
                                  ),
                                ),
                                subtitle: Text(AppLocalizations.of(context)
                                    .translate('sp2')),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddShop(
                                      mobile: mob,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: EdgeInsets.all(15),
                              child: Text(AppLocalizations.of(context)
                                  .translate('sp3')))
                        ],
                      )),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: hasShopData ?? false,
                child: ShopDetail(
                  idMob: 'ID$mob',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
