import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_micron/core/failure.dart';
import 'package:core_micron/core/utils.dart';
import 'package:core_micron/model/employee_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../../core/firebase_constants/firebase-constants.dart';
import '../../../core/typedef.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(firestore: FirebaseFirestore.instance);
});

class HomeRepository {
  final FirebaseFirestore _firestore;
  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _settings =>
      _firestore.collection(FirebaseConstants.settingsCollection);
  CollectionReference get _employees =>
      _firestore.collection(FirebaseConstants.employeesCollection);

  FutureVoid addEmployee({
    required String name,
    required int phone,
  }) async {
    try {
      String docName = await getUsersCount();
      DocumentReference reference = _employees.doc(docName);
      EmployeeModel employeeModel = EmployeeModel(
          name: name,
          reference: reference,
          phone: phone,
          attendance: 0,
          createdTime: DateTime.now(),
          delete: false,
          id: reference.id,
          search: setSearchParam(name));

      List month = [];

      var data = await _settings.doc("settings").get();
      month = data.get("month");
      var currentMonth =
          DateFormat("MMMM y").format(employeeModel!.createdTime!);

      print(month.contains(currentMonth));
      if (!month.contains(currentMonth)) {
        month.add(currentMonth);
        _settings.doc("settings").update({'month': month});
      }

      return right(reference.set(employeeModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future getMonths() async {
    var data = await _settings.doc("settings").get();
    return data.get("month");
  }

  Future<String> getUsersCount() async {
    var userId = await _settings.doc("settings").get();
    await userId.reference.update({
      "employees": FieldValue.increment(1),
    });
    return "E${userId.get("employees")}";
  }

  Stream<List<EmployeeModel>> getEmployees() {
    return _employees
        .where("delete", isEqualTo: false)
        .orderBy('createdTime', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => EmployeeModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<EmployeeModel>> getEmployeesByMonth(DateTime month) {
    print(month);
    print(month.month);
    print(month.day);
    return _employees
        .where("delete", isEqualTo: false)
        .where("createdTime", isGreaterThanOrEqualTo: DateTime(month.year,month.month,1,0,0,0))
        .where("createdTime",
            isLessThanOrEqualTo:
                DateTime(month.year, month.month+1, month.subtract(Duration(days: 1)).day, 23, 59, 59))
        .snapshots()
        .map((event) => event.docs
            .map((e) => EmployeeModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid editEmployee(
      {required String id, required EmployeeModel employeeModel}) async {
    try {
      DocumentReference reference = _employees.doc(id);
      return right(reference.update(employeeModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteEmployee({required String id}) async {
    try {
      DocumentReference reference = _employees.doc(id);
      return right(reference.update({
        "delete": true,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
