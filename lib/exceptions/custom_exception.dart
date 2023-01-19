class CustomException implements Exception{
  String e;

  CustomException(this.e);

  @override
  String toString() {
    return e;
  }
}
