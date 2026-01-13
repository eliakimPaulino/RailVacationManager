import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/repositories/employee_repository.dart';
import 'package:rail_vacation_manager/domain/repositories/vacation_repository.dart';

class RegisterVacationUseCase {
  final VacationRepository vacationRepo;
  final EmployeeRepository employeeRepo;

  RegisterVacationUseCase(this.vacationRepo, this.employeeRepo);

  Future<Result<VacationRequest, Failure>> execute({
    required String requestId,
  }) async {
    final vrRes = await vacationRepo.getById(requestId);
    if (vrRes.isFailure) return Result.failure(vrRes.error);
    final vr = vrRes.value;

    final empRes = await employeeRepo.getById(vr.employeeId);
    if (empRes.isFailure) return Result.failure(empRes.error);

    // ensure Approved
    if (vr.status != VacationStatus.Approved) {
      return Result.failure(
        InvalidValueObject('Only approved vacations can be registered'),
      );
    }

    return Result.success(vr);
  }
}
