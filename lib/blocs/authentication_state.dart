part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationInProgress extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String email;
  final String token;
  const AuthenticationSuccess({required this.email, required this.token});
  @override
  List<Object> get props => [email, token];

  @override
  String toString() {
    return 'AuthenticationSuccess{email: $email, token: $token}';
  }
}

class AuthenticationFailure extends AuthenticationState {
  final Exception? exception;
  const AuthenticationFailure({this.exception});
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'AuthenticationFailure{exception: $exception}';
  }
}
