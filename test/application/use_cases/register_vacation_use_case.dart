import 'package:mocktail/mocktail.dart';
import 'package:rail_vacation_manager/application/use_cases/register_vacation_use_case.dart';
import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:rail_vacation_manager/infrastructure/identity/uuid_employee_id_generator.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_employee_repository.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_vacation_repository.dart';
import 'package:test/test.dart';

class MockVacationRepository extends Mock implements InMemoryVacationRepository {}

class MockEmployeeRepository extends Mock implements InMemoryEmployeeRepository {}

class FakeVacationRequest {
  static VacationRequest approved() => VacationRequest.fake(
    id: '',
    employeeId: EmployeeId.fake(UuidEmployeeIdGenerator().toString()),
    managerId: EmployeeId.fake(UuidEmployeeIdGenerator().toString()),
    status: VacationStatus.Approved,
  );

  static VacationRequest requested() => VacationRequest.fake(
    id: 'req-1',
    employeeId: EmployeeId.fakeEmp(),
    managerId: EmployeeId.fakeMgr(),
    status: VacationStatus.Requested,
    approverNote: 'Good vacation!',
  );
}

class FakeEmployee {
  static Employee any() => Employee.fake();
}

void main() {
  late MockVacationRepository vacationRepo;
  late MockEmployeeRepository employeeRepo;
  late RegisterVacationUseCase useCase;

  setUp(() {
    vacationRepo = MockVacationRepository();
    employeeRepo = MockEmployeeRepository();
    useCase = RegisterVacationUseCase(vacationRepo, employeeRepo);
  });

  test('should fail when vacation request is not found', () async {
    when(() => vacationRepo.getById('req-1')).thenAnswer(
      (_) async => Result.failure(NotFoundFailure('Vacation not Found')),
    );

    final result = await useCase.execute(requestId: 'req-1');

    expect(result.isFailure, true);
    expect(result.error, isA<NotFoundFailure>());
  });

  test('should fail when employee is not found', () async {
    final vacation = FakeVacationRequest.approved();

    when(
      () => vacationRepo.getById('vac-1'),
    ).thenAnswer((_) async => Result.success(vacation));

    when(() => employeeRepo.getById(vacation.employeeId)).thenAnswer(
      (_) async => Result.failure(NotFoundFailure('Employee not found')),
    );

    final result = await useCase.execute(requestId: 'vac-1');

    expect(result.isFailure, true);
    expect(result.error, isA<NotFoundFailure>());
  });

  test('should fail when vacation is not approved', () async {
    final vacation = FakeVacationRequest.requested();

    when(() => vacationRepo.getById('req-1')).thenAnswer((_) async => Result.success(vacation));
    when(() => employeeRepo.getById(vacation.employeeId)).thenAnswer((_) async => Result.success(FakeEmployee.any()));

    final result = await useCase.execute(requestId: 'req-1');

    expect(result.isFailure, true);
  });
}
