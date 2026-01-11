import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:test/test.dart';

class HelperTest {
  EmployeeId employee() => EmployeeId.create(
    'EMP-1',
  ).fold((id) => id, (error) => throw StateError('Invalid EmployeeId: $error'));
  EmployeeId manager() => EmployeeId.create(
    'MGR-1',
  ).fold((id) => id, (error) => throw StateError('Invalid ManagerId: $error'));

  DateRange validPeriod() =>
      DateRange.create(DateTime(2025, 1, 1), DateTime(2025, 1, 10)).fold(
        (range) => range,
        (error) => throw StateError('Invalid DateRange: $error'),
      );
}
void main() {
  final helper = HelperTest();

  test('create VacationRequest from draft status', () {
    final result = VacationRequest.create(
      id: 'VR-1',
      employeeId: helper.employee(),
      managerId: helper.manager(),
      period: helper.validPeriod(),
    );

    expect(result.isSuccess, true);
    expect(result.value.status, VacationStatus.Draft);
  });

  test('should fail when period is invalid', () {
    final invalidPeriod = DateRange.create(
      DateTime(2025, 1, 20),
      DateTime(2025, 1, 10),
    );

    expect(invalidPeriod.isFailure, true);
  });

  test('happy path: request, approve, register', () {
    final vr = VacationRequest.create(
      id: 'VR-1',
      employeeId: helper.employee(),
      period: helper.validPeriod(),
      managerId: helper.manager()
    ).value;

    expect(vr.request().isSuccess, true);
    expect(vr.status, VacationStatus.Requested);

    expect(vr.approve(helper.manager()).isSuccess, true);
    expect(vr.status, VacationStatus.Approved);

    expect(vr.register().isSuccess, true);
    expect(vr.status, VacationStatus.Registered);

  });
}