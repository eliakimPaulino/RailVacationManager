import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/vacation_request.dart';
import 'package:rail_vacation_manager/domain/value_objects/date_range.dart';

abstract class VacationRepository {
  Future<Result<void, Failure>> save(VacationRequest request);
  Future<Result<VacationRequest, Failure>> getById(String id);
  Future<Result<List<VacationRequest>, Failure>> getByEmployeeId(String employeeId);
  Future<Result<List<VacationRequest>, Failure>> getApprovedOverlappingRequests(DateRange period, String employeeId);
}

// overlapping: sobreposição. no contexto de férias, refere-se a períodos de férias que se cruzam ou coincidem em datas.