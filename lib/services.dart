import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee.dart';
import 'package:flutter/material.dart';

class Services {
  static const root = 'http://localhost/EmployeesDB/employees_actions.php';

  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_ALL';
  static const _UPDATE_EMP_ACTION = 'UPDATE_ALL';
  static const _DELETE_EMP_ACTION = 'DELETE_ALL';

  //METHOD TO CREATE EMPLOYEES TABLE
  static Future<String> createTable() async {
    try {
      //ADD PARAMETERS TO PASS REQUEST
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(root), body: map);
      print("Create Table Response: ${response.body}");
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(root), body: map);
      print("Get Employees Response: ${response.body}");
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        return <Employee>[];
      }
    } catch (e) {
      return <Employee>[]; //RETURN EMPTY LIST ON EXCEPTION
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  //METHOD TO ADD EMPLOYEE TO DATABASE
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(Uri.parse(root), body: map);
      print("Add Employee Response: ${response.body}");

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> updateEmployee(
      int empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(Uri.parse(root), body: map);
      print("Update Employee Response: ${response.body}");

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> deleteEmployee(int empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(Uri.parse(root), body: map);
      print("Update Employee Response: ${response.body}");

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
