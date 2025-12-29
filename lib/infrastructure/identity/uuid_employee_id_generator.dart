import 'package:rail_vacation_manager/core/failures.dart';
import 'package:rail_vacation_manager/core/result.dart';
import 'package:rail_vacation_manager/domain/entities/employee_id_generator.dart';
import 'package:rail_vacation_manager/domain/value_objects/employee_id.dart';
import 'package:uuid/uuid.dart';

import '../../core/clock.dart';

class UuidEmployeeIdGenerator implements EmployeeIdGenerator{
  final Uuid _uuid;
  final Clock _clock;

  UuidEmployeeIdGenerator(this._uuid, this._clock);

  @override
  Result<EmployeeId, Failure> generate() {
    final timeStamp = _clock.now().toIso8601String();
    final id = '${_uuid.v4()}-$timeStamp';
    return EmployeeId.create(id);
  }
}