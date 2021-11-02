import 'package:flutter/cupertino.dart';

import 'employee.dart';
import 'services.dart';
import 'package:flutter/material.dart';

class DataTableDemo extends StatefulWidget {
  const DataTableDemo({Key? key}) : super(key: key);

  final String title = 'Flutter Data Table';

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  late List<Employee> _employees;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController
      _firstNameController; //CONTROLLER FOR THE FIRST NAME WE GIVE FOR DATABASE
  late TextEditingController
      _lastNameController; //CONTROLLER FOR THE LAST NAME WE GIVE FOR DATABASE
  late Employee _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); //KEY TO GET THE CONTEXT TO SHOW ON SNACKBAR
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployee();
  }

  //METHOD TO UPDATE TITLE IN THE APPBAR TITLE
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }

    _showProgress('Adding Employee...');
    Services.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployee(); //REFRESH LIST AFTER ADDING EACH VALUE
        _clearValues();
      }
    });
  }

  _getEmployee() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); //RESET THE TITLE...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });

    _showProgress('Updating Employee...');
    Services.updateEmployee(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployee(); //REFRESH LIST AFTER UPDATE
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        _getEmployee(); //REFRESH LIST AFTER DELETE
      }
    });
  }

  //METHOD TO CLEAR TEXTFIELD VALUES
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
  }

  //DATA TABLE TO SHOW EMPLOYEES LIST
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      //SCROLL BOTH VERTICAL AND HORIZONTAL
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
            //DATACOLUMN TO DELETE
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: _employees
              .map(
                (employee) => DataRow(cells: [
                  DataCell(Text(employee.id),
                      //ADD TAP IN ROW TO POPULATE WITH CORRESPONDING VALUES TO UPDATE
                      onTap: () {
                    _showValues(employee);
                    //SET SELECTED EMPLOYEE TO UPDATE
                    _selectedEmployee = employee;

                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(
                      Text(
                        employee.firstName.toUpperCase(),
                      ), onTap: () {
                    _showValues(employee);
                    //SET SELECTED EMPLOYEE TO UPDATE
                    _selectedEmployee = employee;

                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(
                      Text(
                        employee.lastName.toUpperCase(),
                      ), onTap: () {
                    _showValues(employee);
                    //SET SELECTED EMPLOYEE TO UPDATE
                    _selectedEmployee = employee;

                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEmployee(employee);
                    },
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), //WE SHOW PROGRESS IN TITLE...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployee();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),
            //ADD UPDATE AND CANCEL BUTTON
            //SHOW BUTTONS ONLY WHEN UPDATING
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlinedButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updateEmployee(_selectedEmployee);
                        },
                      ),
                      OutlinedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
