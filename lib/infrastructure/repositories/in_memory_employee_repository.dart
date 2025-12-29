import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/repositories/employee_repository.dart';

class InMemoryEmployeeRepository implements EmployeeRepository{

  final Map<String, Employee> _store = {};

  @override
  Future<Result<Employee, Failure>> getById(Employee id) async{
    final e = _store[id.id.value];
    if (e == null) return Result.failure(NotFoundFailure('Employee with id ${id.id.value} not found'));
    return Result.success(e);
  }

  @override
  Future<Result<void, Failure>> save(Employee employee) async{
    _store[employee.id.value] = employee;
    return Result.success(null);
  }

}