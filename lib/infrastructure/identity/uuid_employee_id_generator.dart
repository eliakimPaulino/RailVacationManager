import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee_id_generator.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:uuid/uuid.dart';

class UuidEmployeeIdGenerator implements EmployeeIdGenerator{

  UuidEmployeeIdGenerator();

  @override
  Result<EmployeeId, Failure> generate() {
    final id = Uuid().v4();
    return EmployeeId.create(id);
  }
}