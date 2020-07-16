import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shopeasy/providers/app_language.dart';
import 'package:shopeasy/screens/Progress_page.dart';
import 'package:shopeasy/services/service_locator.dart';

import 'helpers/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  setupLocator();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Shop Easy',
          theme:
              ThemeData(primarySwatch: Colors.blue, accentColor: Colors.white),
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ml', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: Progress(),
        );
      }),
    );
  }
}
