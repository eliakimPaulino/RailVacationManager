import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';

abstract class VacationRepository {
  Future<Result<void, Failure>> save(VacationRequest request);
  Future<Result<VacationRepository, Failure>> getById(String id);
  Future<Result<List<VacationRepository>, Failure>> getByEmployeeId(String employeeId);
  Future<Result<List<VacationRepository>, Failure>> getApprovedOverlappingRequests(DateRange period, String employeeId);
}