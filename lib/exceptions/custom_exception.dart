class CustomException implements Exception{
  String cause, message;

  CustomException(this.cause, this.message);

  @override
  String toString() => cause;
}
