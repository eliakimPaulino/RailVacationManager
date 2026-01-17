import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

class FakeEmployee {
  static Employee any({
    EmployeeId? id,
    String name = 'Test Employee',
    DateTime? hireDate,
    DateTime? terminationDate,
  }) {
    return Employee.create(
      id: id ?? EmployeeId.create('emp-1').value,
      name: name,
      hireDate: hireDate ?? DateTime(2020, 1, 1),
      terminationDate: terminationDate,
    ).value;
  }
}