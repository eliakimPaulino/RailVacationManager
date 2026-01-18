import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:test/test.dart';

void main() {
  late EmployeeId empId;
  late EmployeeId mgrId;
  late DateRange period;

  setUp(() {
    empId = EmployeeId.fakeEmp();
    mgrId = EmployeeId.fakeMgr();
    period = DateRange.fakeRange();
  });
  test('create VacationRequest from draft status', () {
    final result = VacationRequest.create(
      id: 'VR-1',
      employeeId: empId,
      managerId: mgrId,
      period: period,
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

  test('approve: should not approve if status is different from Draft', () {
    final vr = VacationRequest.fake(
      id: 'vreq-1',
      employeeId: empId,
      managerId: mgrId,
      status: VacationStatus.Rejected,
      approverNote: 'Your requisition was rejected!',
    );

    final result = vr.approve(mgrId);

    expect(result.isSuccess, false);
    expect(vr.id, 'vreq-1');
    expect(vr.employeeId, empId);
    expect(vr.managerId, mgrId);
    expect(vr.status, VacationStatus.Rejected);
    expect(vr.approverNote, 'Your requisition was rejected!');
  });

  test(
    'approve: should not approve if manager id is not the assigned manager',
    () {
      final vr = VacationRequest.fake(
        id: 'vreq-1',
        employeeId: empId,
        managerId: mgrId,
        status: VacationStatus.Requested,
        approverNote: 'Your requisition was rejected!',
      );

      print(vr.managerId);

      final result = vr.approve(EmployeeId.fakeEmp());

      result.fold(
        (success) => print('Approved manager'),
        (failure) => print('Manager Id not approved!\n$failure'),
      );

      expect(result.isSuccess, false);
      expect(vr.id, 'vreq-1');
      expect(vr.employeeId, empId);
      expect(vr.managerId, mgrId);
      expect(vr.status, VacationStatus.Requested);
      expect(vr.approverNote, 'Your requisition was rejected!');
    },
  );

  test('reject: should not reject if status is different from requested', () {
    final vr = VacationRequest.fake(
      id: 'vreq-1',
      employeeId: empId,
      managerId: mgrId,
      status: VacationStatus.Approved,
      approverNote: 'Not rejected!',
    );

    final result = vr.reject(mgrId);

    result.fold(
      (success) => print('Rejected request vacation'),
      (failure) =>
          print('Can not Reject. Status is already Approved.\n$failure'),
    );

    expect(result.isSuccess, false);
    expect(vr.id, 'vreq-1');
    expect(vr.employeeId, empId);
    expect(vr.managerId, mgrId);
    expect(vr.status, VacationStatus.Approved);
    expect(vr.approverNote, 'Not rejected!');
  });

  test(
    'reject: should reject if manager id is not the assigned manager',
    () {
      final vr = VacationRequest.fake(
        id: 'vreq-1',
        employeeId: empId,
        managerId: mgrId,
        status: VacationStatus.Requested,
        approverNote: 'Your requisition was rejected!',
      );

      final result = vr.reject(EmployeeId.fakeEmp());

      result.fold(
        (success) => print('Approved manager'),
        (failure) => print('Manager Id not approved!\n$failure'),
      );

    expect(result.isSuccess, false);
    expect(vr.id, 'vreq-1');
    expect(vr.employeeId, empId);
    expect(vr.managerId, mgrId);
    expect(vr.status, VacationStatus.Requested);
    expect(vr.approverNote, 'Your requisition was rejected!');
    },
  );

  test('happy path: request, approve, register', () {
    var managerId = EmployeeId.fakeMgr();

    final vr = VacationRequest.create(
      id: 'vreq-1',
      employeeId: EmployeeId.fakeEmp(),
      managerId: EmployeeId.fakeMgr(),
      period: DateRange.fakeRange(),
    ).value;

    expect(vr.request().isSuccess, true);
    expect(vr.status, VacationStatus.Requested);

    expect(vr.approve(managerId).isSuccess, true);
    expect(vr.status, VacationStatus.Approved);

    expect(vr.register().isSuccess, true);
    expect(vr.status, VacationStatus.Registered);
  });
}
