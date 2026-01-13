import 'package:test/test.dart';
import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

void main() {
  group('Employee.create', () {
    test('should create employee when data is valid', () {
      final id = EmployeeId.create('EMP-1').value;
      final hireDate = DateTime(2025, 4, 1);

      final result = Employee.create(
        id: id,
        name: 'Eliakim',
        hireDate: hireDate,
      );

      expect(result.isSuccess, true);
      expect(result.value.id, id);
      expect(result.value.name, 'Eliakim');
      expect(result.value.hireDate, hireDate);
      expect(result.value.terminationDate, null);
    });

    test('should fail when employee name is empty', () {
      final id = EmployeeId.create('EMP-1').value;
      final hireDate = DateTime(2025, 4, 1);

      final result = Employee.create(id: id, name: '', hireDate: hireDate);

      expect(result.isFailure, true);
      expect(result.error, isA<InvalidValueObject>());
    });

    test('should fail when terminatioDate is before HireDate', () {
      final id = EmployeeId.create('EMP-1').value;
      final hireDate = DateTime(2025, 4, 1);
      final terminationDate = DateTime(2025, 3, 1);

      final result = Employee.create(
        id: id,
        name: '',
        hireDate: hireDate,
        terminationDate: terminationDate,
      );

      expect(result.isFailure, true);
      expect(result.error, isA<InvalidValueObject>());
    });
  });

  group('Employee isActive', () {
    test('should be active when terminationDate is null', () {
      final employee = Employee.create(
        id: EmployeeId.create('EMP-1').value,
        name: 'Eliakim',
        hireDate: DateTime(2025, 4, 1),
      ).value;

      expect(employee.isActive, true);
    });

    test('shuld not be active when termination date is in the past', () {
      final employee = Employee.create(
        id: EmployeeId.create('EMP-1').value,
        name: 'Eliakim',
        hireDate: DateTime(2025, 4, 1),
        terminationDate: DateTime.now().subtract(const Duration(days: 1)),
      ).value;

      print(employee.toString());

      expect(employee.isActive, false);
    });
  });
}
