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
    final employee = empRes.value;

    // ensure Approved
    if (vr.status != VacationStatus.Approved) {
      return Result.failure(
        InvalidValueObject('Only approved vacations can be registered'),
      );
    }

    final consume = employee.consumeDays(vr.daysRequested);
    if (consume.isFailure) return Result.failure(consume.error);

    // register on request aggregate
    final regRes = vr.register();
    if (regRes.isFailure) {
      //rollback
      employee.refundDays(vr.daysRequested);
      return Result.failure(regRes.error);
    }

    final saveEmp = await employeeRepo.save(employee);
    if (saveEmp.isFailure) {
      //rollback
      employee.refundDays(vr.daysRequested);
      return Result.failure(saveEmp.error);
    }

    final saveVr = await vacationRepo.save(vr);
    if (saveVr.isFailure) {
      //rollback
      employee.refundDays(vr.daysRequested);
      await employeeRepo.save(employee);
      return Result.failure(saveVr.error);
    }

    return Result.success(vr);
  }
}
