import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:meta/meta.dart';

import '../../core/failures.dart';
import '../../core/result.dart';
import '../value_objects/date_range.dart';

class VacationRequest {
  final String id;
  final EmployeeId employeeId;
  final EmployeeId? managerId;
  final DateRange period;
  VacationStatus _status;
  String? approverNote;

  VacationRequest._(
    this.id,
    this.employeeId,
    this.managerId,
    this.period,
    this._status,
    this.approverNote,
  );

  static Result<VacationRequest, Failure> create({
    required String id,
    required EmployeeId employeeId,
    EmployeeId? managerId,
    required DateRange period,
  }) {
    if (period.daysInclusive <= 0) {
      return Result.failure(
        InvalidValueObject('Vacation period must be at least one day long'),
      );
    }
    return Result.success(
      VacationRequest._(
        id,
        employeeId,
        managerId,
        period,
        VacationStatus.Draft,
        null,
      ),
    );
  }

  @visibleForTesting
  static VacationRequest fake({
    required String id,
    required EmployeeId employeeId,
    required EmployeeId managerId,
    required VacationStatus status,
    String? approverNote,
  }) {
    return VacationRequest._(
      id,
      employeeId,
      managerId,
      DateRange.create(DateTime(2025, 1, 1), DateTime(2025, 1, 29)).value,
      status,
      approverNote,
    );
  }

  VacationStatus get status => _status;

  Result<void, Failure> request() {
    if (_status != VacationStatus.Draft) {
      return Result.failure(InvalidValueObject('Can only request from Draft'));
    }
    _status = VacationStatus.Requested;
    return Result.success(null);
  }

  Result<void, Failure> approve(EmployeeId approver, {String? note}) {
    if (_status != VacationStatus.Requested) {
      return Result.failure(
        InvalidValueObject('Can only approve from Requested'),
      );
    }
    if (managerId != null && managerId!.value != approver.value) {
      return Result.failure(
        InvalidValueObject(
          'Only the assigned manager can approve this request',
        ),
      );
    }
    _status = VacationStatus.Approved;
    approverNote = note;
    return Result.success(null);
  }

  Result<void, Failure> reject(EmployeeId approver, {String? note}) {
    if (_status != VacationStatus.Requested) {
      return Result.failure(
        InvalidValueObject('Can only reject from Requested'),
      );
    }
    if (managerId != null && managerId!.value != approver.value) {
      return Result.failure(
        InvalidValueObject('Only the assigned manager can reject this request'),
      );
    }
    _status = VacationStatus.Rejected;
    approverNote = note;
    return Result.success(null);
  }

  Result<void, Failure> register() {
    if (_status != VacationStatus.Approved) {
      return Result.failure(
        InvalidValueObject('Can only register from Approved'),
      );
    }
    _status = VacationStatus.Registered;
    return Result.success(null);
  }

  int get daysRequested => period.daysInclusive;

  @override
  String toString() =>
      'VacationRequest(id: $id, employeeId: $employeeId, managerId: $managerId, period: $period, status: $_status, approverNote: $approverNote)';
}
