import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/repositories/employee_repository.dart';
import 'package:rail_vacation_manager/domain/repositories/vacation_repository.dart';

import '../../domain/value_objects/employee_id.dart';

class ApproveVacationUseCase {
  final VacationRepository vacationRepo;
  final EmployeeRepository employeeRepo;

  ApproveVacationUseCase(this.vacationRepo, this.employeeRepo);

  Future<Result<VacationRequest, Failure>> execute({ required String requestId, required String approverIdRaw, String? note}) async {
    final vacationRes = await vacationRepo.getById(requestId);
    if (vacationRes.isFailure) return Result.failure(vacationRes.error);
    final vacationResponse = vacationRes.value;

    final approverRes = EmployeeId.create(approverIdRaw);
    if (approverRes.isFailure) return Result.failure(InvalidValueObject('Invalid Approver ID'));
    final approver = approverRes.value;

    // athorize and approve within aggregate
    final approval = vacationResponse.approve(approver, note: note);
    if (approval.isFailure) return Result.failure(approval.error);

    final saveRes = await vacationRepo.save(vacationResponse);
    if (saveRes.isFailure) return Result.failure(saveRes.error);

    return Result.success(vacationResponse);
  }
}