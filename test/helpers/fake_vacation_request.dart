import 'package:rail_vacation_manager/core/vacation_status.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';

class FakeVacationRequest {
  static VacationRequest approved({
    String id = 'req-1',
    EmployeeId? employeeId,
  }) {
    return VacationRequest.fake(
      id: id,
      employeeId: employeeId ?? EmployeeId.create('emp-1').value,
      status: VacationStatus.Approved,
    );
  }

  static VacationRequest pending({
    String id = 'req-2',
    EmployeeId? employeeId,
  }) {
    return VacationRequest.fake(
      id: id,
      employeeId: employeeId ?? EmployeeId.create('emp-1').value,
      status: VacationStatus.Requested,
    );
  }
}