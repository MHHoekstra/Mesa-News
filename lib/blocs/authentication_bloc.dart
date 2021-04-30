import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mesa_news/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SignInRequested) {
      yield AuthenticationInProgress();
      try {
        final token = await authenticationRepository.signIn(
            email: event.email, password: event.password);
        if (token.isNotEmpty) {
          yield AuthenticationSuccess(email: event.email, token: token);
        } else {
          yield AuthenticationFailure();
        }
      } on Exception catch (e) {
        log(e.toString());
        yield AuthenticationFailure(exception: e);
      } catch (e) {
        log(e.toString());
        yield AuthenticationFailure();
      }
    }
    if (event is LogoutRequested) {
      yield AuthenticationInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(AuthenticationState state) {
    if (state is AuthenticationSuccess) {
      return {
        "email": state.email,
        "token": state.token,
      };
    } else {
      return {};
    }
  }

  @override
  AuthenticationState fromJson(Map<String, dynamic> json) {
    if (json['email'] != null && json['token'] != null) {
      return AuthenticationSuccess(email: json['email'], token: json['token']);
    } else {
      return AuthenticationInitial();
    }
  }
}
