class FatalException extends Error {
  final String message;

  FatalException(this.message);

  @override
  String toString() => 'FatalException: with messsage: `$message`';
}
