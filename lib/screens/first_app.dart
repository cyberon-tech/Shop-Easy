import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/screens/home_page.dart';
import 'package:shopeasy/widgets/language_widget.dart';

class FirstApp extends StatefulWidget {
  @override
  _FirstAppState createState() => _FirstAppState();
}

class _FirstAppState extends State<FirstApp> {
  PageController pageController = PageController(initialPage: 0);
  GlobalKey<PageContainerState> key = GlobalKey();
//  bool first;
  bool lpage = false;

  void activateSkip(int index) {
    if (index == 5) {
      setState(() {
        lpage = true;
      });
    }
  }

  void _setFirst(bool first) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first', true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageIndicatorContainer(
          key: key,
          child: PageView(
            children: <Widget>[
              Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                      Flexible(
//                        child: Container(
//                          child: Opacity(
//                            opacity: 0.2,
//                            child: Image.asset(
//                              'assets/j6.png',
//                              fit: BoxFit.fill,
//                            ),
//                          ),
//                        ),
//                        flex: 1,
//                      ),
                      Flexible(flex: 2, child: ChangeLanguage()),
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Opacity(
                            opacity: 0.2,
                            child: Image.asset(
                              'assets/j7.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j1')}.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j2')}.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j3')}.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j4')}.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/${AppLocalizations.of(context).translate('j5')}.png',
                fit: BoxFit.cover,
              ),
            ],
            controller: pageController,
            reverse: false,
            onPageChanged: (val) {
              activateSkip(val);
            },
          ),
          indicatorColor: Colors.grey,
          indicatorSelectorColor: Theme.of(context).primaryColor,
          align: IndicatorAlign.bottom,
          length: 6,
          indicatorSpace: 10.0,
        ),
        floatingActionButton: lpage == false
            ? Container()
            : FloatingActionButton.extended(
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  _setFirst(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                label: Text(
                  AppLocalizations.of(context).translate('done'),
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
      ),
    );
  }
}
