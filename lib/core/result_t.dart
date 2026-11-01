sealed class Result<T, E> {
  const new();

  T unwrap() => switch (this) {
    Ok(value: final val) => val,
    Err() => throw StateError('Called `unwrap()` on Err'),
  };
  E unwrapErr() => switch (this) {
    Err(value: final val) => val,
    Ok() => throw StateError('Called `unwrapErr()` on Ok'),
  };
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const new(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E value;
  const new(this.value);
}
