import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

abstract class EmployeeIdGenerator {
  Result<EmployeeId, Failure> generate();
}