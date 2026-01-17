import '../../core/failures.dart';
import '../../core/result.dart';
import '../value_objects/employee_id.dart';

class Employee {
  final EmployeeId id;
  final String name;
  final DateTime hireDate;
  final DateTime? terminationDate;

  Employee._({
    required this.id,
    required this.name,
    required this.hireDate,
    this.terminationDate,
  });

  static Result<Employee, Failure> create({
    required EmployeeId id,
    required String name,
    required DateTime hireDate,
    DateTime? terminationDate,
  }) {
    if (name.trim().isEmpty) {
      return Result.failure(
        InvalidValueObject('Employee name cannot be empty'),
      );
    }
    if (terminationDate != null && terminationDate.isBefore(hireDate)) {
      return Result.failure(
        InvalidValueObject('Termination date can not be before hire date.'),
      );
    }
    return Result.success(
      Employee._(
        id: id,
        name: name,
        hireDate: hireDate,
        terminationDate: terminationDate,
      ),
    );
  }

  factory Employee.fake() {
    return Employee._(id: EmployeeId.create('Fake').value, name: 'FakeName', hireDate: DateTime.now());
  }

  bool get isActive =>
      terminationDate == null || terminationDate!.isAfter(DateTime.now());

  @override
  String toString() =>
      'Employee(id: ${id.value}, name: $name, hireDate: $hireDate, terminationDate: $terminationDate)';
}
