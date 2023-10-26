class Response<T> {
  final int code;
  final String message;
  final T result;

  Response(this.code, this.message, this.result);
}
