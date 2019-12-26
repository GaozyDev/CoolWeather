import 'package:coolweather/main_page.dart';
import 'package:coolweather/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'about_page.dart';
import 'focus_district_list_page.dart';
import 'more_day_forecast_page.dart';
import 'add_district_page.dart';
import 'setting_page.dart';
import 'data/unit_model.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  /// 单位model
  final unitModel = UnitModel();
  unitModel.initUnit();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  runApp(ChangeNotifierProvider<UnitModel>.value(
    value: unitModel,
    child: MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: "/",
      routes: {
//        "/": (context) => TestPage(),
        "/": (context) => MainPage(),
        "more_day_forecast":(context) => MoreDayForecast(),
        "focus_district_list": (context) => FocusDistrictListPage(),
        "select_district": (context) => AddDistrictPage(),
        "setting": (context) => SettingPage(),
        "about": (context) => AboutPage(),
      },
    ),
  ));
}
