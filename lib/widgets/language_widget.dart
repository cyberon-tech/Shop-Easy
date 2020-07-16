import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/providers/app_language.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Color selected = Colors.blue, notSelected = Colors.blueGrey;
  Color e = Colors.blueGrey, m = Colors.blueGrey;
  String lang = '';

  void _getLang() async {
    var prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('language_code') ?? "";
    setState(() {
      if (lang.isEmpty || lang == 'en') {
        e = selected;
      } else {
        m = selected;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getLang();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Container(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              AppLocalizations.of(context).translate('lw1'),
              style: TextStyle(fontSize: 20),
            )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: selected,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'English',
                          style: TextStyle(color: e),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          'En',
                          style: TextStyle(fontSize: 50, color: e),
                        ),
                        Icon(Icons.radio_button_checked, color: e),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  onTap: () {
                    appLanguage.changeLanguage(Locale("en"));
                    setState(() {
                      e = selected;
                      m = notSelected;
                    });
                  },
                ),
                InkWell(
                  splashColor: selected,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'മലയാളം',
                          style: TextStyle(color: m),
                        ),
                        Text(
                          'അ',
                          style: TextStyle(fontSize: 50, color: m),
                        ),
                        Icon(Icons.radio_button_checked, color: m),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  onTap: () {
                    appLanguage.changeLanguage(Locale("ml"));
                    setState(() {
                      m = selected;
                      e = notSelected;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
