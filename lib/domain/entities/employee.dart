import '../../core/failures.dart';
import '../../core/result.dart';
import '../value_objects/employee_id.dart';

class Employee {
  final EmployeeId id;
  final String name;
  int _vacationDaysBalance; // mutable - real world state changes

  Employee._(this.id, this.name, this._vacationDaysBalance);

  static Result<Employee, Failure> create(EmployeeId id, String name, int initialBalance) {
    if (name.trim().isEmpty) {
      return Result.failure(InvalidValueObject('Employee name cannot be empty'));
    }
    if (initialBalance < 0) {
      return Result.failure(InvalidValueObject('Initial vacation days balance cannot be negative'));
    }
    return Result.success(Employee._(id, name, initialBalance));
  }

  int get vacationDaysBalance => _vacationDaysBalance;

  Result<void, Failure> consumeDays(int days) {
    if (days <= 0) {
      return Result.failure(InsufficientVacationDays('Not enough days. Have: $_vacationDaysBalance, tried to consume: $days'));
    }
    _vacationDaysBalance -= days;
    return Result.success(null);
  }

  void refundDays(int days) {
    _vacationDaysBalance += days;
  }

  @override
  String toString() => 'Employee(id: $id, name: $name, vacationDaysBalance: $_vacationDaysBalance)';

}