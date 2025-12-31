import 'package:rail_vacation_manager/domain/entities/employee.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

Employee createTestEmployee({required String id, required String name, required int balance}) {
  final empId = EmployeeId.create(id);
   if (empId.isFailure) throw Exception('Invalid EmployeeId for test');
  return Employee.create(empId.value, name, balance).value;
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