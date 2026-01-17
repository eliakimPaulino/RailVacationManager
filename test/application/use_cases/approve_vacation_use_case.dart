import 'package:rail_vacation_manager/application/use_cases/approve_vacation_use_case.dart';
import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_employee_repository.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_vacation_repository.dart';
import 'package:test/test.dart';

import '../../helpers/test_fixtures.dart';

void main() {
  late InMemoryVacationRepository vacationRepo;
  late InMemoryEmployeeRepository employeeRepo;
  late ApproveVacationUseCase useCase;

  setUp(() {
    vacationRepo = InMemoryVacationRepository();
    employeeRepo = InMemoryEmployeeRepository();
    useCase = ApproveVacationUseCase(vacationRepo, employeeRepo);
  });

  test('should approve a request vacation', () async {
    final vr = createTestApprovedVacationRequest(
      requestId: 'req-1',
      start: DateTime(2026, 01, 06),
      end: DateTime(2026, 01, 25),
    );

    vr.reject(vr.employeeId);

    await vacationRepo.save(vr);

    final result = await useCase.execute(
      requestId: 'req-1',
      approverIdRaw: EmployeeId.fakeMgr().value,
    );

    expect(result.isSuccess, true);
    expect(result.value.status, VacationStatus.Approved);
  });
}
