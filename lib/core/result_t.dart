sealed class Result<T, E> {
  const new();

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T unwrap() => switch (this) {
    Ok(value: final val) => val,
    Err() => throw StateError('Called `unwrap()` on Err'),
  };
  E unwrapErr() => switch (this) {
    Err(value: final val) => val,
    Ok() => throw StateError('Called `unwrapErr()` on Ok'),
  };

  void onResult({
    required void Function(E err) onErr,
    required void Function(T val) onOk,
  }) {
    switch (this) {
      case Ok(value: final val):
        onOk(val);
        break;
      case Err(value: final err):
        onErr(err);
        break;
    }
  }

  R fold<R>({
    required R Function(E err) onErr,
    required R Function(T val) onOk,
  }) => switch (this) {
    Ok(value: final val) => onOk(val),
    Err(value: final err) => onErr(err),
  };
  Future<R> foldAsync<R>({
    required Future<R> Function(E err) onErr,
    required Future<R> Function(T val) onOk,
  }) async {
    final res = switch (this) {
      Ok(value: final val) => await onOk(val),
      Err(value: final err) => await onErr(err),
    };
    return res;
  }
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const new(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E value;
  const new(this.value);
}
