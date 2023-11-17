part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class LoadingAuthState extends AuthState {
  const LoadingAuthState();
}

class AuthenticatedState extends AuthState {
  const AuthenticatedState();
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class RegisterSuccessState extends AuthState {
  const RegisterSuccessState();
}

class AuthError extends AuthState {
  final String errorMsg;

  const AuthError(this.errorMsg);
}
