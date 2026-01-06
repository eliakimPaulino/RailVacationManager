import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/repositories/vacation_repository.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';

import '../../core/vacation_status.dart';

class InMemoryVacationRepository implements VacationRepository {
  final Map<String, VacationRequest> _store = {};

  @override
  Future<Result<List<VacationRequest>, Failure>> getApprovedOverlappingRequests(
    DateRange period,
    String employeeId,
  ) async {
    final list = _store.values.where(
          (r) =>

              r.employeeId.value == employeeId &&
              r.status == VacationStatus.Approved &&
              r.period.overlaps(period),

        ).toList();
    return Result.success(list);
  }

  @override
  Future<Result<List<VacationRequest>, Failure>> getByEmployeeId(String employeeId) async {
    final list = _store.values
        .where((r) => r.employeeId.toString() == employeeId)
        .toList();
    return Result.success(list);
  }

  @override
  Future<Result<VacationRequest, Failure>> getById(String id) async {
    final r = _store[id];
    if (r == null) {
      return Result.failure(
        NotFoundFailure('VacationRequest with id $id not found'),
      );
    }
    return Result.success(r);
  }

  @override
  Future<Result<void, Failure>> save(VacationRequest request) async {
    _store[request.id] = request;
    return Result.success(null);
  }
}
