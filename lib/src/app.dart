import 'package:flutter/material.dart';
import 'package:team_management/src/ui/screens/home.dart';

import 'utils/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          primaryColor: Constants.primaryGreenColor,
          primarySwatch: Colors.green,
          accentColor: Color(0xFF0A0A0A),
          accentColorBrightness: Brightness.light,
          buttonColor: Constants.primaryGreenColor,
          dialogTheme: DialogTheme(),
          buttonTheme: ButtonThemeData(
              buttonColor: Constants.primaryGreenColor,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              textTheme: ButtonTextTheme.accent,
              disabledColor: Color(0x50000000),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))),
          tabBarTheme: TabBarTheme(
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Theme.of(context).textTheme.subtitle,
            unselectedLabelStyle: Theme.of(context).textTheme.subtitle,
          ),
          disabledColor: Color(0x50000000),
          iconTheme: IconThemeData(color: Constants.blackColor),
          textTheme: TextTheme(
              display3: TextStyle(
                fontSize: 56.0,
              ),
              display2: TextStyle(fontSize: 45.0),
              display1: TextStyle(fontSize: 34.0),
              headline: TextStyle(fontSize: 24.0),
              title: TextStyle(fontSize: 20.0, color: Colors.white),
              subtitle: TextStyle(
                fontSize: 20.0,
                color: Color(0x70525257),
                letterSpacing: 1,
              ),
              subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              body2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
              body1: TextStyle(fontSize: 12.0, letterSpacing: 1),
              caption: TextStyle(fontSize: 12.0),
              button: TextStyle(
                fontSize: 16.0,
              ),
              display4: TextStyle(fontSize: 12, fontWeight: FontWeight.w300))),
      home: MyApp(),
    );
  }
}
