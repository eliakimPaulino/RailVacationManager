import 'package:rail_vacation_manager/core/clock.dart';

class SystemClock implements Clock{
  @override
  DateTime now() => DateTime.now();

}