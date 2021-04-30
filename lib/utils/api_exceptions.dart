abstract class ApiException implements Exception {
  const ApiException();
}

class ConnectionException extends ApiException {
  const ConnectionException();
}

class ServerErrorException extends ApiException {
  final int? code;
  final String? message;
  const ServerErrorException({this.code, this.message});

  @override
  String toString() {
    return 'ServerErrorException{code: $code, message: $message}';
  }
}

class ClientErrorException extends ApiException {
  final int? code;
  final String? message;
  const ClientErrorException({this.code, this.message});

  @override
  String toString() {
    return 'ClientErrorException{code: $code, message: $message}';
  }
}

class UnknownErrorException extends ApiException {
  const UnknownErrorException();
}
