import 'employee.dart';
import 'services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

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

  _addEmployee() {}

  _getEmployee() {}

  _updateEmployee() {}
  _deleteEmployee() {}

  //METHOD TO CLEAR TEXTFIELD VALUES
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
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
                        _updateEmployee();
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
        ],
      )),
    );
  }
}
