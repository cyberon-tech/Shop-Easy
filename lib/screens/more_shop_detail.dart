import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/services/calls_and_messages_service.dart';
import 'package:shopeasy/services/service_locator.dart';

class MapPage extends StatefulWidget {
  String sName, sCategory, sMob, sLat, sLong;
  int sStatus, sHomeDelivery;

  MapPage(
      {this.sCategory,
      this.sName,
      this.sHomeDelivery,
      this.sLat,
      this.sLong,
      this.sMob,
      this.sStatus});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  List<Marker> shopMarkers = [];
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  String shopName = '', shopCategory = '', shopMob = '';
  double shopLat, shopLong;
  int shopStatus = 0, shopHomeDelivery = 1;
  BitmapDescriptor customIcon;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.5), 'assets/pn.png');
    setState(() {});
    _markers.add(
      Marker(
        icon: customIcon,
        markerId: MarkerId("Shop Easy"),
        draggable: false,
        position: LatLng(shopLat, shopLong),
      ),
    );
  }

  void initData() {
    setState(() {
      shopName = widget.sName;
      shopCategory = widget.sCategory;
      shopStatus = widget.sStatus;
      shopHomeDelivery = widget.sHomeDelivery;
      shopLat = double.tryParse(widget.sLat);
      shopLong = double.tryParse(widget.sLong);
      shopMob = widget.sMob;
      _center = LatLng(shopLat, shopLong);
    });
    setCustomMapPin();
  }

  @override
  void initState() {
    super.initState();
    initData();
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
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
//                            fontFamily: 'Righteous',
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
                                Text(AppLocalizations.of(context)
                                    .translate('msd1')),
                                Text(
                                  shopCategory,
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
//                                    fontFamily: 'Righteous',
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 1,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .translate('slw2')),
                                Text(
                                  shopStatus == 1
                                      ? AppLocalizations.of(context)
                                          .translate('slw3')
                                      : AppLocalizations.of(context)
                                          .translate('slw4'),
                                  style: TextStyle(
                                    color: shopStatus == 1
                                        ? Colors.green
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
//                                    fontFamily: 'Righteous',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context).translate('msd2')),
                        Text(
                          shopHomeDelivery.bitLength == 0
                              ? AppLocalizations.of(context).translate('msd4')
                              : AppLocalizations.of(context).translate('msd3'),
                          style: TextStyle(
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
//                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        shopHomeDelivery != 1
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)
                                          .translate('msd5')),
                                      Text(
                                        shopMob,
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
//                                      fontFamily: 'Righteous',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  InkWell(
                                    splashColor: Theme.of(context).primaryColor,
                                    child: Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          child: Icon(Icons.call),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('call'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _service.call(shopMob);
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        _center == null
                            ? Container()
                            : Container(
                                padding: EdgeInsets.all(2),
                                height: 250,
                                child: _markers.isEmpty
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : customIcon == null
                                        ? Container
                                        : GoogleMap(
                                            onMapCreated: _onMapCreated,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: _center,
                                              zoom: 15,
                                            ),
                                            markers: _markers,
                                          ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
