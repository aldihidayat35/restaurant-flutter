/// Sealed class for managing UI state when calling Web API.
sealed class ResultState<T> {
  const ResultState();
}

class ResultLoading<T> extends ResultState<T> {
  const ResultLoading();
}

class ResultLoaded<T> extends ResultState<T> {
  final T data;
  const ResultLoaded(this.data);
}

class ResultError<T> extends ResultState<T> {
  final String message;
  const ResultError(this.message);
}
