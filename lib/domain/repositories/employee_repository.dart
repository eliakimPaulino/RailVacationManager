import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<Result<Employee, Failure>> getById(String id);
  Future<Result<void, Failure>> save(Employee employee);
}