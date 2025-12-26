abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class InsufficientVacationDays extends Failure {
  InsufficientVacationDays(super.message);
}

class OverlappingVacation extends Failure {
  OverlappingVacation(super.message);
}

class UnauthorizedApprover extends Failure {
  UnauthorizedApprover(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class InvalidValueObject extends Failure {
  InvalidValueObject(super.message);
}