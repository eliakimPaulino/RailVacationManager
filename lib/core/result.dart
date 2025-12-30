class Result<T, E> {
  final T? _value;
  final E? _error;
  final bool _isSuccess;

  const Result._(this._value, this._error,this._isSuccess);

  bool get isSuccess => _isSuccess;
  bool get isFailure => !_isSuccess;

  T get value {
    if (!isSuccess) {
      throw StateError('Tried to access value of a Failure Result');
    }
    return _value as T;
  }

  E get error {
    if (isSuccess) {
      throw StateError('Tried to access error of a Success Result');
    }
    return _error as E;
  }

  static Result<T, E> success<T, E>(T value) => Result._(value, null, true);
  static Result<T, E> failure<T, E>(E error) => Result._(null, error, false);

  R fold<R>(R Function(T v) onSuccess, R Function(E e) onFailure) =>
    isSuccess ? onSuccess(_value as T) : onFailure(_error as E);
  
}