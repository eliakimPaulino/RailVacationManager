import 'package:meta/meta.dart';
import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange._(this.start, this.end);

  static Result<DateRange, Failure> create(DateTime start, DateTime end) {
    final normalizedStart = DateTime(
      start.year,
      start.month,
      start.day,
    ).toLocal();
    final normalizedEnd = DateTime(end.year, end.month, end.day).toLocal();

    if (normalizedEnd.isBefore(normalizedStart)) {
      return Result.failure(
        InvalidValueObject('End date must be after start date.'),
      );
    }

    return Result.success(DateRange._(normalizedStart, normalizedEnd));
  }

  // total de dias contados dentro do período. Dia inicial e final inclusos.
  int get daysInclusive => end.difference(start).inDays + 1;

  @visibleForTesting
  static DateRange fakeRange() =>
      DateRange._(DateTime(2021, 08, 03), DateTime(2022, 12, 18));

  bool overlaps(DateRange other) {
    return !(other.end.isBefore(start) || other.start.isAfter(end));
  }
}
