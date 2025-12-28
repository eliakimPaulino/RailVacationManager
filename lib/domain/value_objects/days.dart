import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';

class Days {
  final int value;
  const Days._(this.value);

  static Result<Days, Failure> create(int value) {
    if (value < 0) {
      return Result.failure(InvalidValueObject('Days cannot be negative'));
    }
    return Result.success(Days._(value));
  }

  @override
  String toString() => 'Days(value: ${value.toString()})';
}