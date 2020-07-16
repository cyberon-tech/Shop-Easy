import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/widgets/find_shop_list_widget.dart';

class PlaceCategoryList1 extends StatefulWidget {
  String sCategory;

  PlaceCategoryList1(this.sCategory);

  @override
  _PlaceCategoryList1State createState() => _PlaceCategoryList1State();
}

class _PlaceCategoryList1State extends State<PlaceCategoryList1> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final _form = GlobalKey<FormState>();
  List places = [];
  String place;
  Position _currentPosition;
  String district;
  bool isPlaceSelected = false;
  bool isChanged = false;
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
        district = "${place.subAdministrativeArea}";
      });
      if (district != '') {
        getPlaces();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPlaces() async {
    var test;
    databaseReference.child("$district").once().then((DataSnapshot snapshot) {
      setState(() {
        test = snapshot.value ?? {};
        places = test.keys.toList();
//        size = test.length;
        if (places.isEmpty) {
          check = false;
        }
        print(places);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        places.isEmpty
            ? check == false
                ? Text(AppLocalizations.of(context).translate('ndf'))
                : Container(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
            : isPlaceSelected == true
                ? Container()
                : Container(
//                      height: 100,
                    child: Form(
                      key: _form,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate('pcl1'),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppLocalizations.of(context)
                                .translate('pcl2');
                          }
                          return null;
                        },
                        value: place,
                        items: places
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            place = value;
                            isPlaceSelected = true;
                            isChanged = !isChanged;
                          });
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
        isPlaceSelected == false
            ? Container()
            : FindShopsList(
                sCategory: widget.sCategory,
                sPlace: place,
              ),
      ],
    );
  }
}
