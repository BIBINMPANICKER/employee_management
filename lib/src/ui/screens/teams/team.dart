import 'package:flutter/material.dart';
import 'package:team_management/src/models/team_model.dart';
import 'package:team_management/src/utils/db_factory.dart';

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  List<TeamModel> strings = <TeamModel>[];
  TextEditingController _teamNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getAllTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Teams'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView.builder(
            itemCount: strings.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(strings[index].teamName),
                    onTap: () {
                      _showDialog(strings[index]);
                    },
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addDialog();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ///-----------------------------------functions----------------------------

  //returns dialog for choosing delete/edit
  void _showDialog(team) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    .teamMemberDb
                    .showTeamMembers(team.id)
                    .then((onValue) {
                  Navigator.of(context).pop();
                  if (onValue == 0) {
                    DbFactory().teamDb.deleteTeam(team.id).then((onValue) {
                      getAllTeams();
                    });
                  } else {
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                            }),
                        content: new Text(
                            '${onValue.toString()} employee(s) are working in this team')));
                  }
                });
              },
            ),
            new FlatButton(
              child: new Text("EDIT"),
              onPressed: () {
                _teamNameController.text = team.teamName;
                Navigator.of(context).pop();
                _addDialog(
                  id: team.id,
                );
              },
            ),
          ],
        );
      },
    );
  }

  //returns dialog for add/edit new team
  void _addDialog({int id = 0}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "${id == 0 ? 'Add' : 'Edit'} Team",
            style: TextStyle(color: Colors.black),
          ),
          content: new TextField(
            controller: _teamNameController,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(id == 0 ? "ADD" : "SAVE"),
              onPressed: () {
                if (id == 0) {
                  DbFactory()
                      .teamDb
                      .addTeam(_teamNameController.text)
                      .then((onValue) {
                    getAllTeams();
                  });
                } else {
                  DbFactory()
                      .teamDb
                      .updateTeam(id, _teamNameController.text)
                      .then((onValue) {
                    getAllTeams();
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //fetch all teams for listing in team_list page
  getAllTeams() {
    DbFactory().teamDb.getTeams().then((onValue) {
      setState(() {
        strings = onValue;
        _teamNameController.clear();
      });
    });
  }
}
