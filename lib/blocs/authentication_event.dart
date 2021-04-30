part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignInRequested extends AuthenticationEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});

  @override
  List<Object> get props {
    return [email, password];
  }
}

class LogoutRequested extends AuthenticationEvent {
  const LogoutRequested();

  @override
  List<Object> get props {
    return [];
  }
}
