import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:rail_vacation_manager/infrastructure/identity/uuid_employee_id_generator.dart';
import 'package:rail_vacation_manager/infrastructure/time/system_clock.dart';
import 'package:uuid/uuid.dart';

Employee createTestEmployee({required String name, required int balance}) {
  final idGenerator = UuidEmployeeIdGenerator(Uuid(), SystemClock());

  final idRes = idGenerator.generate();
  if (idRes.isFailure) throw Exception('Failed to generate EmployeeId for test');

  // Agora criamos o employee com o ID gerado
  final empId = idRes.value;
  return Employee.create(empId, name, balance).value;
}

VacationRequest createTestApprovedVacationRequest({
  required String requestId,
  required String employeeId,
  required DateTime start,
  required DateTime end,
}) {
  final empId = EmployeeId.create(employeeId).value;
  final period = DateRange.create(start, end).value;

  final vr = VacationRequest.create(id: requestId, employeeId: empId, period: period).value;

  vr.request();
  vr.approve(empId);
  return vr;
}