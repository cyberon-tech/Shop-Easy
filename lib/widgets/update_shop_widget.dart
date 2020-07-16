import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/helpers/app_localization.dart';

class UpdateShop extends StatefulWidget {
  String mobile;
  String sName;
  String sCategory;
  int hDelivery;

  UpdateShop({this.mobile, this.hDelivery, this.sCategory, this.sName});

  @override
  _UpdateShopState createState() => _UpdateShopState();
}

class _UpdateShopState extends State<UpdateShop> {
  final _form = GlobalKey<FormState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final databaseReference = FirebaseDatabase.instance.reference();
  List categories = [];
  int size = 0;
  bool isSwitched = false;

  String mob;
  String shopName;
  String shopCategory;
  int shopStatus = 0;
  int homeDelivery = 0;
  String _currentLatitude;
  String _currentLongitude;
  String _currentDistrict;
  String _currentPlace;
  String _currentPin;
  Position _currentPosition;
  String demoCategory;

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
        _currentPin = "PIN-${place.postalCode}";
        _currentDistrict = "${place.subAdministrativeArea}";
        _currentLatitude = "${_currentPosition.latitude}";
        _currentLongitude = "${_currentPosition.longitude}";
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

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (result == ConnectivityResult.none) {
      _showDialog('No internet',
          "No connection found! \nPlease check your internet connection.");
    }
  }

  Future<void> getCategories() async {
    var test;
    databaseReference.child("categories").once().then((DataSnapshot snapshot) {
      setState(() {
        test = snapshot.value;
        categories = test.values.toList();
        size = test.length;
//        print(test.values);
      });
    });
  }

//  Future<void> getCategories() async {
//    databaseReference.child("categories").once().then((DataSnapshot snapshot) {
//      setState(() {
//        size = snapshot.value['no-ctg'];
//        for (int i = 1; i <= size; i++) {
//          categories.add(snapshot.value['ctg-$i']);
//        }
//      });
//    });
//  }

  Future<void> addData() async {
    await databaseReference.child('$_currentDistrict/$_currentPin/ID$mob').set({
      'shop_name': shopName,
      'shop_status': shopStatus,
      'shop_category': shopCategory,
      'shop_latitude': _currentLatitude,
      'shop_longitude': _currentLongitude,
      'home_delivery_status': homeDelivery,
      'mob': mob,
    });
    if (_currentPlace.isNotEmpty) {
      await databaseReference
          .child('$_currentDistrict/$_currentPlace/ID$mob')
          .set({
        'shop_name': shopName,
        'shop_status': shopStatus,
        'shop_category': shopCategory,
        'shop_latitude': _currentLatitude,
        'shop_longitude': _currentLongitude,
        'home_delivery_status': homeDelivery,
        'mob': mob,
      });
    }
  }

  _setLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('place', '$_currentPlace');
    await prefs.setString('pin', '$_currentPin');
    await prefs.setString('district', '$_currentDistrict');
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      _showDialog('Notification', 'Check the form again!');
      return;
    }
    _form.currentState.save();
    _setLocation();
    addData();
//    _showDialog('Notification', 'Shop added succesfully');
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      mob = widget.mobile;
      shopName = widget.sName;
      demoCategory = widget.sCategory;
      homeDelivery = widget.hDelivery;
      if (homeDelivery == 1) {
        isSwitched = true;
      }
    });
    getCategories();
    _getCurrentLocation();
    _checkInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      AppLocalizations.of(context).translate('sdw7'),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate('asw2'),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).translate('asw3');
                  }
                  return null;
                },
                initialValue: shopName,
                onChanged: (value) {
                  setState(() => shopName = value);
                },
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: demoCategory,
                ),
//                validator: (value) {
//                  if (value?.isEmpty ?? true) {
//                    return 'Shop category required!';
//                  }
//                  return null;
//                },
                value: shopCategory,
                items: categories
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    shopCategory = value;
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child:
                          Text(AppLocalizations.of(context).translate('asw6'))),
                  Column(
                    children: <Widget>[
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            if (isSwitched == true) {
                              homeDelivery = 1;
                            } else {
                              homeDelivery = 0;
                            }
                          });
                        },
                        activeTrackColor: Colors.lightBlueAccent,
                        activeColor: Colors.blue,
                      ),
                      homeDelivery == 1
                          ? Text(AppLocalizations.of(context).translate('asw8'))
                          : Text(
                              AppLocalizations.of(context).translate('asw7')),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Text(
                AppLocalizations.of(context).translate('asw9'),
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    color: Colors.teal,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      AppLocalizations.of(context).translate('usw2'),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (shopCategory == null) {
                        setState(() {
                          shopCategory = widget.sCategory;
                        });
                      }
                      _saveForm();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
