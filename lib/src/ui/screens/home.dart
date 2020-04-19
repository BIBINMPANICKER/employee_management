import 'package:flutter/material.dart';
import 'package:team_management/src/ui/screens/teams/team.dart';

import 'employees/employee.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp(context);
  }

  MaterialApp buildMaterialApp(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Team'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Team())),
            ),
            ListTile(
              title: Text('Employees'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Employee())),
            )
          ],
        ),
      ),
    );
  }
}
