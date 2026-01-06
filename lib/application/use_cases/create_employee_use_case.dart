import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/entities/employee_id_generator.dart';
import 'package:rail_vacation_manager/domain/repositories/employee_repository.dart';

import '../../core/failures.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository employeeRepository;
  final EmployeeIdGenerator idGenerator;

  CreateEmployeeUseCase({
    required this.employeeRepository,
    required this.idGenerator,
  });

  Future<Result<Employee, Failure>> execute({
    required String name,
    required int initialBalance,
  }) async {
    final idRes = idGenerator.generate();
    if (idRes.isFailure) return Result.failure(idRes.error);

    final employee = Employee.create(idRes.value, name, initialBalance);
    if (employee.isFailure) return Result.failure(employee.error);

    final saveRes = await employeeRepository.save(employee.value);
    if (saveRes.isFailure) return Result.failure(saveRes.error);

    return Result.success(employee.value);
  }
}
