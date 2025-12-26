import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';

class EmployeeId {
  final String value;

  const EmployeeId._(this.value);

  static Result<EmployeeId, dynamic> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return Result.failure(InvalidValueObject('EmployeeId cannot be empty'));
    }
    return Result.success(EmployeeId._(trimmed));
  }

  @override
  String toString() => 'EmployeeId(value: $value)';
}