import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/repositories/employee_repository.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

import '../../domain/entities/vacation_request.dart';
import '../../domain/repositories/vacation_repository.dart';

class RequestVacationUseCase {
  final EmployeeRepository employeeRepo;
  final VacationRepository vacationRepo;

  RequestVacationUseCase(this.employeeRepo, this.vacationRepo);

  Future<Result<VacationRequest, Failure>> execute({
    required String requestId,
    required String employeeIdRaw,
    required DateTime start,
    required DateTime end,
    String? managerIdRaw,
  }) async {
    // create VOs
    final employeeIdRes = EmployeeId.create(employeeIdRaw);
    if (employeeIdRes.isFailure) {
      return Result.failure(InvalidValueObject('Invalid Employee ID'));
    }
    final dateRangeRes = DateRange.create(start, end);
    if (dateRangeRes.isFailure) {
      return Result.failure(dateRangeRes.error);
    }

    final employeeId = employeeIdRes.value;

    final period = dateRangeRes.value;

    final employeeRes = await employeeRepo.getById(employeeId);
    if (employeeRes.isFailure) {
      return Result.failure(employeeRes.error);
    }

    final employee = employeeRes.value;
    // business rule: sufficient days
    final days = period.daysInclusive;

    if (employee.vacationDaysBalance < days) {
      return Result.failure(
        InsufficientVacationDays(
          'Employee has only ${employee.vacationDaysBalance} vacation days, but requested $days days',
        ),
      );
    }

    // check overlapping approved vacations
    final overlapRes = await vacationRepo.getApprovedOverlappingRequests(
      period,
      employeeId.value,
    );
    if (overlapRes.isFailure) return Result.failure(overlapRes.error);
    if (overlapRes.value.isNotEmpty) {
      return Result.failure(
        OverlappingVacation(
          'There are overlapping approved vacation requests in the requested period',
        ),
      );
    }

    // create request
    final managerId = managerIdRaw != null
        ? (EmployeeId.create(managerIdRaw).value)
        : null;

    final vacationRes = VacationRequest.create(
      id: requestId,
      employeeId: employeeId,
      managerId: managerId,
      period: period,
    );

    if (vacationRes.isFailure) return Result.failure(vacationRes.error);
    final vacationResponse = vacationRes.value;

    // move to requested status
    final requestRes = vacationResponse.request();
    if (requestRes.isFailure) return Result.failure(requestRes.error);

    //business rule: deduct vaction days
    employee.consumeDays(days);

    final saveRes = await vacationRepo.save(vacationResponse);
    if (saveRes.isFailure) return Result.failure(saveRes.error);

    return Result.success(vacationResponse);
  }
}
