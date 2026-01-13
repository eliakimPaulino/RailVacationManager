import 'package:rail_vacation_manager/core/clock.dart';
import 'package:rail_vacation_manager/infrastructure/identity/uuid_employee_id_generator.dart';
import 'package:test/test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class FakeUuid extends Uuid {
  final String value;

  FakeUuid(this.value);

  @override
  String v4({V4Options? config, Map<String, dynamic>? options}) => value;
}

class FakeClock extends Clock {
  final DateTime fixed;

  FakeClock(this.fixed);

  @override
  DateTime now() => fixed;

  @override
  String toString() {
    return 'DateTime ${fixed.day}/${fixed.month}/${fixed.year}';
  }
}

void main () {
  test('happy path: should generate id mixing uuid and timestamp', () {
    // arrange
    final fakeUuid = FakeUuid('123e4567-e89b-12d3-a456-426614174000');
    print(fakeUuid.value);
    final fakeClock = FakeClock(DateTime(2025, 1, 1, 12, 0, 0));
    print(fakeClock);

    final generator = UuidEmployeeIdGenerator();
    
    // act
    final result = generator.generate();

    //assert
    expect(result.isSuccess, true);

    final empId = result.value;

    expect(empId.value, '123e4567-e89b-12d3-a456-426614174000-2025-01-01T12:00:00.000');
  });
}