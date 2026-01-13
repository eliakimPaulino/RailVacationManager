import 'package:test/test.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

void main() {
  group('Employee.create', () {
    test('should create employee with valid data', () {
      final id = EmployeeId.create('emp-1').value;

      final result = Employee.create(id, 'John', 10);

      expect(result.isSuccess, true);
      expect(result..value.vacationDaysBalance, 10);
    });

    test('should fail if name is empty', () {
      final id = EmployeeId.create('emp-1').value;

      final result = Employee.create(id, '   ', 10);

      expect(result.isFailure, true);
    });

    test('should fail if initial balance is negative', () {
      final id = EmployeeId.create('emp-1').value;

      final result = Employee.create(id, 'John', -1);

      expect(result.isFailure, true);
    });
  });

  group('Vacation days consumption', () {
    late Employee employee;

    setUp(() {
      final id = EmployeeId.create('emp-1').value;
      employee = Employee.create(id, 'John', 10).value;
    });

    test('should consume vacation days correctly', () {
      final result = employee.consumeDays(5);

      expect(result.isSuccess, true);
      expect(employee.vacationDaysBalance, 5);
    });

    test('should fail if consuming zero or negative days', () {
      final result = employee.consumeDays(0);

      expect(result.isFailure, true);
      expect(employee.vacationDaysBalance, 10);
    });
  });

  group('Refund vacation days', () {
    test('should increase vacation balance', () {
      final id = EmployeeId.create('emp-1').value;
      final employee = Employee.create(id, 'John', 5).value;

      employee.refundDays(3);

      expect(employee.vacationDaysBalance, 8);
    });
  });
}
