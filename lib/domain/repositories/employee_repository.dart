import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

abstract class EmployeeRepository {
  Future<Result<Employee, Failure>> getById(EmployeeId id);
  Future<Result<void, Failure>> save(Employee employee);
}