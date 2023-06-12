class _Exception implements Exception {
  final String message;
  final String prefix;

  _Exception({required this.message, required this.prefix});

  @override
  String toString() => "$prefix$message";
}

class FetchDataException extends _Exception {
  FetchDataException(String message)
      : super(message: message, prefix: "Error During Communication: ");
}

class NoConnectivityException extends _Exception {
  NoConnectivityException(String message)
      : super(message: message, prefix: "No Connectivity: ");
}
