import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/helpers/app_localization.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  PageController pageController = PageController(initialPage: 0);
  GlobalKey<PageContainerState> key = GlobalKey();
  String lang;
//  String j1 = 'j1', j2 = 'j2', j3 = 'j3', j4 = 'j4', j5 = 'j5';
//
//  void _getLang() async {
//    var prefs = await SharedPreferences.getInstance();
//    lang = prefs.getString('language_code') ?? "";
//    setState(() {
//      if (lang == 'ml') {
//        j1 = 'm1';
//        j2 = 'm2';
//        j3 = 'm3';
//        j4 = 'm4';
//        j5 = 'm5';
//      }
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _getLang();
//  }

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
            },
          ),
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
        body: PageIndicatorContainer(
          key: key,
          child: PageView(
            children: <Widget>[
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j1')}.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j2')}.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j3')}.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j4')}.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j5')}.png',
                fit: BoxFit.fill,
              ),
            ],
            controller: pageController,
            reverse: false,
          ),
          indicatorColor: Colors.grey,
          indicatorSelectorColor: Theme.of(context).primaryColor,
          align: IndicatorAlign.bottom,
          length: 5,
          indicatorSpace: 10.0,
        ),
      ),
    );
  }
}
