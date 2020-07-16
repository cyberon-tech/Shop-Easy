import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/widgets/update_shop_widget.dart';

class ShopDetail extends StatefulWidget {
  String idMob;

  ShopDetail({this.idMob});

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

//  PageUpdater pageUpdater = PageUpdater();

  bool shopStatus = false;
  String shopName = '';
  String shopCategory = '';
  int homeDelivery = 0;
  String location = '';
  String mob = '';
  String place;
  String pin;
  String district;
  Position _currentPosition;
  String _currentPlace;
  String _currentDistrict;

//  bool isDeleted = false;

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
        _currentDistrict = "${place.subAdministrativeArea}";
        _currentPlace = "${place.locality}";
        if (_currentPlace.isEmpty) {
          _currentPlace = "PIN-${place.postalCode}";
        }
      });
      _getLocation();
    } catch (e) {
      print(e);
    }
  }

  _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    place = await prefs.getString('place');
    pin = await prefs.getString('pin');
    district = await prefs.getString('district');
    mob = await prefs.getString('mob');
    setState(() {
      if (pin == null) {
        pin = _currentPlace;
        district = _currentDistrict;
      }
      if (place == null) {
        location = '$pin' + ', ' + '$district';
      } else {
        location = '$place' + ', ' + '$district';
      }
    });
    getShop();
  }

  Future<void> statusUpdate() async {
    int status;
    if (shopStatus == true) {
      status = 1;
    } else {
      status = 0;
    }
    await databaseReference.child('$district/$pin/ID$mob').update({
      'shop_status': status,
    });
    if (place.isNotEmpty) {
      await databaseReference.child('$district/$place/ID$mob').update({
        'shop_status': status,
      });
    }
  }

  _showDeleteDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  databaseReference.child('$district/$pin/ID$mob').remove();
                  if (place.isNotEmpty) {
                    databaseReference.child('$district/$place/ID$mob').remove();
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void deleteShop() async {
    _showDeleteDialog('Delete Shop', 'Are you sure you want to delete shop!');
  }

  Future<void> getShop() async {
    Map<dynamic, dynamic> test;
    databaseReference
        .child("$district/$pin/ID$mob")
        .onValue
        .listen((Event event) {
      setState(() {
        test = event.snapshot.value;
        shopName = test['shop_name'];
        shopCategory = test['shop_category'];
        homeDelivery = test['home_delivery_status'];
        if (test['shop_status'] == 1) {
          shopStatus = true;
        } else {
          shopStatus = false;
        }
//        print(test);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(AppLocalizations.of(context).translate('sdw1')),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate('slw1')),
                  Text(
                    shopName,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      fontFamily: 'Righteous',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate('msd1')),
                          Text(
                            shopCategory,
                            style: TextStyle(
                              color: Colors.blueGrey.shade700,
                              fontSize: 22,
                              fontFamily: 'Righteous',
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                                AppLocalizations.of(context).translate('sdw3')),
                            Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Switch(
                                  value: shopStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      shopStatus = value;
                                      statusUpdate();
                                    });
                                  },
                                  activeColor: Colors.blue,
                                  activeTrackColor: Colors.lightBlueAccent,
                                ),
                                shopStatus == true
                                    ? Text(
                                        AppLocalizations.of(context)
                                            .translate('sdw4'),
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade700,
//                                          fontFamily: 'Righteous',
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate('sdw5'),
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade700,
//                                          fontFamily: 'Righteous',
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('sdw2')),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 22,
                      fontFamily: 'Righteous',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(AppLocalizations.of(context).translate('msd2')),
                  homeDelivery == 1
                      ? Text(
                          AppLocalizations.of(context).translate('msd3'),
                          style: TextStyle(
                            color: Colors.blueGrey.shade700,
                            fontSize: 22,
//                            fontFamily: 'Righteous',
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context).translate('msd4'),
                          style: TextStyle(
                            color: Colors.blueGrey.shade700,
                            fontSize: 22,
                            fontFamily: 'Righteous',
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(AppLocalizations.of(context).translate('msd5')),
                  Text(
                    mob,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 22,
                      fontFamily: 'Righteous',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('sp4'),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        color: Colors.redAccent,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        label: Text(
                          AppLocalizations.of(context).translate('sdw6'),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          deleteShop();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton.icon(
                        color: Colors.teal,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          AppLocalizations.of(context).translate('sdw7'),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateShop(
                                mobile: mob,
                                hDelivery: homeDelivery,
                                sCategory: shopCategory,
                                sName: shopName,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
