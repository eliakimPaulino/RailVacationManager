import 'package:rail_vacation_manager/application/use_cases/approve_vacation_use_case.dart';
import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_employee_repository.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_vacation_repository.dart';
import 'package:test/test.dart';

import '../../helpers/test_fixtures.dart';

void main() {
  late InMemoryVacationRepository vacationRepo;
  late InMemoryEmployeeRepository employeeRepo;
  late ApproveVacationUseCase useCase;

  setUp(() {
    print('[SETUP] Initializing repositories and use case');
    vacationRepo = InMemoryVacationRepository();
    employeeRepo = InMemoryEmployeeRepository();
    useCase = ApproveVacationUseCase(vacationRepo, employeeRepo);
    print('[SETUP] Done');
  });

  test('should approve a request vacation', () async {
    print('[TEST] Creating vacation request');

    final vr = createTestApprovedVacationRequest(
      requestId: 'req-1',
      employeeId: 'emp-1',
      start: DateTime(2026, 01, 06),
      end: DateTime(2026, 01, 25),
    );

    print('[TEST] Vacation request created: ${vr.id}');
    // print('[TEST] Rejecting vacation request');

    vr.reject(vr.employeeId);

    print('[TEST] Saving vacation request');
    await vacationRepo.save(vr);

    print('[TEST] Executing ApproveVacationUseCase');
    final result = await useCase.execute(
      requestId: 'req-1',
      approverIdRaw: 'emp-1',
    );

    print('[TEST] Use case executed');
    print('[TEST] Result success: ${result.isSuccess}');
    print('[TEST] Vacation status: ${result.value.status}');

    expect(result.isSuccess, true);
    expect(result.value.status, VacationStatus.Approved);
  });
}
