import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/screens/more_shop_detail.dart';

class ShopsList extends StatefulWidget {
  String sCategory;

  ShopsList({this.sCategory});

  @override
  _ShopsListState createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentPlace;
  String _currentDistrict;

//  List _listKeys;
  List _listValues;
  String shopCategory;
  int size = 0;
  bool check;

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
        getShops();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShops() async {
    Map<dynamic, dynamic> test;
    databaseReference
        .child("$_currentDistrict/$_currentPlace")
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        test = snapshot.value ?? {};
//        _listKeys = test.keys.toList();
        _listValues = test.values.toList();
        size = test.length;
        for (int i = 0; i < size; i++) {
          if (_listValues[i]['shop_category'] == shopCategory) {
            check = true;
          }
        }
        if (check != true) {
          check = false;
        }
//        print(_listKeys);
//        print(_listValues);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      shopCategory = widget.sCategory;
    });
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _listValues == null
        ? Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        : Column(
            children: <Widget>[
              check == false
                  ? Text(AppLocalizations.of(context).translate('ndf'))
                  : Container(),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: size,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (_listValues[index]['shop_category'] != shopCategory ||
                      _listValues[index]['shop_status'] == 0) {
                    return Container();
                  } else {
                    return InkWell(
                      splashColor: Colors.grey,
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .translate('slw1')),
                                Text(
                                  _listValues[index]['shop_name'],
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade700,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .translate('slw2')),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('slw3'),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(
                              sCategory: _listValues[index]['shop_category'],
                              sStatus: _listValues[index]['shop_status'],
                              sMob: _listValues[index]['mob'],
                              sLong: _listValues[index]['shop_longitude'],
                              sLat: _listValues[index]['shop_latitude'],
                              sHomeDelivery: _listValues[index]
                                  ['home_delivery_status'],
                              sName: _listValues[index]['shop_name'],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: size,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (_listValues[index]['shop_category'] != shopCategory ||
                      _listValues[index]['shop_status'] == 1) {
                    return Container();
                  } else {
                    return InkWell(
                      splashColor: Colors.grey,
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .translate('slw1')),
                                Text(
                                  _listValues[index]['shop_name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade700,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .translate('slw2')),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('slw4'),
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(
                              sCategory: _listValues[index]['shop_category'],
                              sStatus: _listValues[index]['shop_status'],
                              sMob: _listValues[index]['mob'],
                              sLong: _listValues[index]['shop_longitude'],
                              sLat: _listValues[index]['shop_latitude'],
                              sHomeDelivery: _listValues[index]
                                  ['home_delivery_status'],
                              sName: _listValues[index]['shop_name'],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          );
  }
}
