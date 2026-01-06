import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange._(this.start, this.end);

  static Result<DateRange, Failure> create(DateTime start, DateTime end) {

    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);

    if ( normalizedEnd.isBefore(normalizedStart)) {
      return Result.failure(
        InvalidValueObject('End date must be after start date.'),
      );
    }

    return Result.success(DateRange._(normalizedStart, normalizedEnd));
  }

  int get daysInclusive => end.difference(start).inDays + 1;

  bool overlaps(DateRange other) {
    return !(other.end.isBefore(start) || other.start.isAfter(end));
  }
}
