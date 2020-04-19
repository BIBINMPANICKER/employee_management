import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_management/src/models/team_member.dart';
import 'package:team_management/src/utils/constants.dart';
import 'package:team_management/src/utils/db_factory.dart';

import 'add_employee.dart';

class Employee extends StatefulWidget {
  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  List<TeamMemberModel> strings = <TeamMemberModel>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getAllEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text('Employees'),
            leading: BackButton(onPressed: () => Navigator.of(context).pop())),
        body: ListView(
            padding: EdgeInsets.all(12),
            children: strings.map((item) => employeeList(item)).toList()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddEmployee(null, action: Constants.ADD)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ///------------------------------------functions----------------------------------

  //custom widget for showing details of each employee
  Widget employeeList(TeamMemberModel item) {
    return InkWell(
      onTap: () {
        _showDialog(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.employeeName,
            style: Theme.of(context).textTheme.headline,
          ),
          SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Age : ${item.age}',
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.black54)),
              Text('City : ${item.city}',
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.black54))
            ],
          ),
          SizedBox(height: 6),
          item.teamLead != null
              ? Text('Team Lead : ${item.teamLead}',
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.black54))
              : SizedBox(),
          item.teamLead != null ? SizedBox(height: 6) : SizedBox(),
          SizedBox(height: 6),
          Wrap(
            children: '${item.teamName}'
                .split(',')
                .map((item) => teamNameChip(item))
                .toList(),
            spacing: 8,
            runSpacing: 8,
          ),
          SizedBox(height: 6),
          Divider(thickness: 1)
        ],
      ),
    );
  }

  //chips for showing team names
  Widget teamNameChip(item) {
    return Container(
      decoration: new BoxDecoration(
          border: Border.all(color: Colors.black26),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 1
                1.0, // vertical, move down 1
              ),
            )
          ],
          borderRadius: new BorderRadius.circular(30)),
      child: Text(item,
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.black54)),
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
    );
  }

  //fetch all the data needed to populate in employee list page
  getAllEmployees() {
    DbFactory().teamMemberDb.getMemberTeam().then((onValue) {
      setState(() {
        strings = onValue;
      });
    });
  }

  //returns delete or edit dialog
  void _showDialog(item) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext ctxt) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Actions",
            style: TextStyle(color: Colors.black),
          ),
          content: new Text("Select delete or edit"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("DELETE"),
              onPressed: () {
                DbFactory()
                    .employeeDb
                    .showAssignedEmployees(item.id)
                    .then((onValue) {
                  Navigator.of(ctxt).pop();
                  //if there is no employees assigned under the selected employee
                  if (onValue == 0) {
                    DbFactory()
                        .employeeDb
                        .deleteEmployees(item.id)
                        .then((onValue) {
                      getAllEmployees(); //refresh employee list page
                    });
                  } else {
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                            }),
                        content: new Text(
                            '${onValue.toString()} employee(s) are there under his leadership')));
                  }
                });
              },
            ),
            new FlatButton(
              child: new Text("EDIT"),
              onPressed: () {
                Navigator.of(ctxt).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddEmployee(item, action: Constants.EDIT)));
              },
            ),
          ],
        );
      },
    );
  }
}
