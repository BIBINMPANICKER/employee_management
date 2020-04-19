import 'package:flutter/material.dart';
import 'package:team_management/src/models/employee_model.dart';
import 'package:team_management/src/models/team_member.dart';
import 'package:team_management/src/models/team_model.dart';
import 'package:team_management/src/utils/constants.dart';
import 'package:team_management/src/utils/db_factory.dart';
import 'package:team_management/src/utils/utils.dart';

import 'employee.dart';

class AddEmployee extends StatefulWidget {
  final String action;
  final TeamMemberModel teamMemberModel;

  AddEmployee(this.teamMemberModel, {this.action});

  @override
  _AddEmployeeState createState() => _AddEmployeeState(action);
}

class _AddEmployeeState extends State<AddEmployee> {
  final String action;
  TextEditingController _employeeNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  bool _isSwitched = false;
  List<EmployeeModel> dropdownList = [];
  List<TeamModel> data = [];
  List<int> selected = [];
  EmployeeModel selectedTeamLead;
  final _formKey = GlobalKey<FormState>();

  _AddEmployeeState(this.action);

  @override
  void initState() {
    initialLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  saveInput();
                }
              },
              child: Text(
                'Save',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(top: 16),
          children: <Widget>[
            ListTile(
              title: Text('Employee Name'),
              subtitle: TextFormField(
                controller: _employeeNameController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter name here'),
                validator: (value) {
                  return validateNameAndCity(value);
                },
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text('Age'),
              subtitle: TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return validateAge(value);
                },
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text(
                'Enter city',
              ),
              subtitle: TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter city name'),
                validator: (value) {
                  return validateNameAndCity(value);
                },
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text('Is Team Lead'),
              trailing: Switch(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
              ),
            ),
            !_isSwitched
                ? dropdownList.length > 0
                    ? ListTile(
                        title: Text('Team Lead'),
                        subtitle: DropdownButton<EmployeeModel>(
                          isExpanded: true,
                          hint: new Text(action == Constants.ADD
                              ? "Select a user"
                              : widget.teamMemberModel.teamLead ??
                                  "Select a user"),
                          value: selectedTeamLead,
                          onChanged: (newValue) {
                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              selectedTeamLead = newValue;
                              print(newValue);
                            });
                          },
                          items: dropdownList.map((user) {
                            return new DropdownMenuItem<EmployeeModel>(
                              value: user,
                              child: Text(
                                user.employeeName,
                                style: new TextStyle(color: Colors.black54),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          'No Team lead found',
                          style: TextStyle(color: Colors.black45),
                        ),
                        leading: Icon(Icons.error),
                      )
                : SizedBox(),
            data.length > 0
                ? ListTile(
                    title: Text('Team'),
                    subtitle: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          spacing: 8,
                          children:
                              data.map((item) => filterChip(item)).toList(),
                        )),
                  )
                : ListTile(
                    title: Text(
                      'Atleast 1 team is required to add an employee',
                      style: TextStyle(color: Colors.black45),
                    ),
                    leading: Icon(Icons.error),
                  ),
          ],
        ),
      ),
    );
  }

  ///---------------------------------functions---------------------------------------
  //chips for showing team names
  Widget filterChip(TeamModel item) {
    return FilterChip(
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item.teamName),
      ),
      labelStyle: TextStyle(color: Colors.white),
      onSelected: (bool value) {
        setState(() {
          if (selected.contains(item.id)) {
            selected.remove(item.id);
          } else {
            selected.add(item.id);
          }
        });
      },
      selected: selected.contains(item.id),
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.black38,
      elevation: 4,
      checkmarkColor: Colors.white,
    );
  }

//validate the name/city filed
  validateNameAndCity(String value) {
    if (value.length < 5 || value.length > 15) {
      return 'name must be 5 to 15 characters only';
    }
    return null;
  }

//validate the ahe field
  validateAge(String value) {
    if (int.tryParse(value) == null) {
      return 'Age must be integer';
    }
    return null;
  }

//add or update the employee details
  saveInput() async {
    //if adding new employee
    if (action == Constants.ADD) {
      if (selected.isNotEmpty) {
        if (_isSwitched) {
          await DbFactory().teamMemberDb.addEmployee(
              employeeName: _employeeNameController.text,
              age: _ageController.text,
              city: _cityController.text,
              isTeamLead: _isSwitched,
              teamLead: 0,
              teams: selected);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Employee()));
          showToast('Employee added successfully');
        } else {
          if (selectedTeamLead == null || selectedTeamLead?.id == 0) {
            showToast('Please select the Team lead');
          } else {
            await DbFactory().teamMemberDb.addEmployee(
                employeeName: _employeeNameController.text,
                age: _ageController.text,
                city: _cityController.text,
                isTeamLead: _isSwitched,
                teamLead: selectedTeamLead.id,
                teams: selected);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Employee()));
            showToast('Employee added successfully');
          }
        }
      } else {
        showToast('Please select atleast 1 Team');
      }
      //if editing the employee details
    } else {
      if (selected.isNotEmpty) {
        if (_isSwitched) {
          await DbFactory().teamMemberDb.updateEmployee(
              employeeName: _employeeNameController.text,
              age: _ageController.text,
              city: _cityController.text,
              isTeamLead: _isSwitched,
              teamLead: 0,
              teams: selected,
              id: widget.teamMemberModel.id);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Employee()));
          showToast('Employee Updated successfully');
        } else {
          if (selectedTeamLead == null || selectedTeamLead?.id == 0) {
            showToast('Please select the Team lead');
          } else {
            await DbFactory().teamMemberDb.updateEmployee(
                employeeName: _employeeNameController.text,
                age: _ageController.text,
                city: _cityController.text,
                isTeamLead: _isSwitched,
                teamLead: selectedTeamLead.id,
                teams: selected,
                id: widget.teamMemberModel.id);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Employee()));
            showToast('Employee Updated successfully');
          }
        }
      } else {
        showToast('Please fill all the fields & select atleast 1 Team');
      }
    }
  }

  //function executed in initState
  initialLoad() {
    if (action == Constants.EDIT) {
      _employeeNameController.text = widget.teamMemberModel.employeeName;
      _ageController.text = widget.teamMemberModel.age.toString();
      _cityController.text = widget.teamMemberModel.city;
      _isSwitched = widget.teamMemberModel.teamLead == null;
    }
    DbFactory().employeeDb.getAllTeamLead().then((onValue) {
      dropdownList = onValue;
      DbFactory().teamDb.getTeams().then((teamList) {
        setState(() {
          data = teamList;
          if (action == Constants.EDIT) {
            dropdownList
                .removeWhere((obj) => obj.id == widget.teamMemberModel.id);

            dropdownList.forEach((f) {
              if (f.id == widget.teamMemberModel.teamLeadId) {
                selectedTeamLead = f;
                print(f.id);
              }
            });
            widget.teamMemberModel.teamName.split(',').forEach((f) {
              data.forEach((m) {
                if (f == m.teamName) {
                  selected.add(m.id);
                }
              });
            });
          }
        });
      });
    });
  }
}
