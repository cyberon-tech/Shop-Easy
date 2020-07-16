import 'package:flutter/material.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/screens/place_category_list_page.dart';
import 'package:shopeasy/screens/settings_page.dart';
import 'package:shopeasy/widgets/shops_list_widget.dart';

import 'about_page.dart';
import 'place_category_list_page1.dart';

enum popUp { settings, about }

class ShopCategory extends StatefulWidget {
  String sCategory;

  ShopCategory({this.sCategory});

  @override
  _ShopCategoryState createState() => _ShopCategoryState();
}

class _ShopCategoryState extends State<ShopCategory> {
  final _form = GlobalKey<FormState>();
  String shopCategory;
  bool isIdea = false;
  bool first = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      shopCategory = widget.sCategory;
    });
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
          elevation: 0,
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
                  ];
                })
          ],
        ),
        body: shopCategory == null
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Text(
                          shopCategory,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontFamily: 'RussoOne'),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 1,
                          ),
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).accentColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('scp1'),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              first = true;
                              isIdea = !isIdea;
                              print("tapped");
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        first == true
                            ? isIdea == true
                                ? PlaceCategoryList(widget.sCategory)
                                : PlaceCategoryList1(widget.sCategory)
                            : ShopsList(
                                sCategory: shopCategory,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
