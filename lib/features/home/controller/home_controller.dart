import 'package:core_micron/features/home/repository/home_repository.dart';
import 'package:core_micron/model/employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

final getEmployeesProvider = StreamProvider((ref) {
  return ref.read(homeControllerProvider.notifier).getEmployees();
});
final homeControllerProvider = NotifierProvider<HomeController, bool>(() {
  return HomeController();
});
final getMonthProvider = FutureProvider((ref) {
  return ref.read(homeControllerProvider.notifier).getMonths();
});
final getEmployeeByMonthProvider = StreamProvider.autoDispose.family((ref,DateTime month)  {
  return ref.read(homeControllerProvider.notifier).getEmployeesByMonth(month: month);
});

class HomeController extends Notifier<bool> {
  HomeRepository get _homeRepository => ref.read(homeRepositoryProvider);

  void addEmployee({
    required String name,
    required int phone,
    required BuildContext context,
  }) async {
    final res = await ref
        .read(homeRepositoryProvider)
        .addEmployee(phone: phone, name: name);
    res.fold((l) => showSnackBar(context, "Error"), (r) {
      showSnackBar(context, "Employee Added");
      return Navigator.pop(context);
    });
  }

  Future getMonths() {
    return _homeRepository.getMonths();
  }

  Stream<List<EmployeeModel>> getEmployees() {
    return _homeRepository.getEmployees();
  }

  void editEmployee({
    required String id,
    required EmployeeModel employeeModel,
    required BuildContext context,
  }) async {
    final res = await _homeRepository.editEmployee(
        id: id, employeeModel: employeeModel);
    res.fold((l) => showSnackBar(context, "error"),
        (r) {
      Navigator.pop(context);
          showSnackBar(context, "Employee Edited");
        });
  }
  void deleteEmployee({
    required String id,

    required BuildContext context,
  }) async {
    final res = await _homeRepository.deleteEmployee(
        id: id, );
    res.fold((l) => showSnackBar(context, "error"),
            (r) {
          showSnackBar(context, "Deleted");
        });
  }
  Stream<List<EmployeeModel>> getEmployeesByMonth({required DateTime month}) {
    return _homeRepository.getEmployeesByMonth(month);
  }
    @override
  bool build() {
    return false;
    // TODO: implement build
    throw UnimplementedError();
  }
}
