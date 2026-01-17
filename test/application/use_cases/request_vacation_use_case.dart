import 'package:rail_vacation_manager/application/use_cases/request_vacation_use_case.dart';
import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_employee_repository.dart';
import 'package:rail_vacation_manager/infrastructure/repositories/in_memory_vacation_repository.dart';
import 'package:test/test.dart';

import '../../helpers/test_fixtures.dart';

void main() {
  late InMemoryEmployeeRepository employeeRepo;
  late InMemoryVacationRepository vacationRepo;
  late VacationRequestUseCase useCase;

  setUp(() {
    employeeRepo = InMemoryEmployeeRepository();
    vacationRepo = InMemoryVacationRepository();
    useCase = VacationRequestUseCase(employeeRepo, vacationRepo);
  });

  test('should create vacation request when balance is sufficient', () async {
    // Arrange
    final employee = createTestEmployee(
      name: 'Eliakim Paulino França',
      hireDate: DateTime(2025, 4, 1),
    );
    await employeeRepo.save(employee);

    final dbData = await employeeRepo.getById(employee.id);
    print(dbData.value);

    // Act
    final result = await useCase.execute(
      requestId: 'req-1',
      employeeIdRaw: employee.id.value,
      start: DateTime(2024, 7, 1),
      end: DateTime(2024, 7, 5),
      managerIdRaw: EmployeeId.fakeMgr().value,
    );

    // Assert
    expect(result.isSuccess, isTrue);
    final vr = result.value;
    expect(vr.employeeId.value, equals(employee.id.value));
    expect(vr.period.start, equals(DateTime(2024, 7, 1)));
    expect(vr.period.end, equals(DateTime(2024, 7, 5)));
    expect(vr.status, equals(VacationStatus.Requested));

    final updatedEmpRes = await employeeRepo.getById(employee.id);
    expect(updatedEmpRes.isSuccess, isTrue);
  });
}
