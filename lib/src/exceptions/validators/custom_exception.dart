class CustomException implements Exception {
  Map<String, dynamic> error;
  CustomException(this.error);
}