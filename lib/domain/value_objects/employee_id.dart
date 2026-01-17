import 'package:meta/meta.dart';
import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';

class EmployeeId {
  final String value;

  const EmployeeId._(this.value);

  static Result<EmployeeId, Failure> create(String id) {
    if (!id.contains('-')) {
      return Result.failure(
        InvalidValueObject('EmployeeId must contain a hyphen'),
      );
    }
    return Result.success(EmployeeId._(id));
  }

  factory EmployeeId.fake(String value) {
    return EmployeeId._(value);
  }

  @visibleForTesting
  factory EmployeeId.fakeEmp() => EmployeeId._('0f4k3123-4f67-8a00-1k3e-56789f4k3001');

  @visibleForTesting
  factory EmployeeId.fakeMgr() => EmployeeId._('0f4k3123-m467-n400-g3r3e-56789f4k3010');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'EmployeeId(value: $value)';
}
