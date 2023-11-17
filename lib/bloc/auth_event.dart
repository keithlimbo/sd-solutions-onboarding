part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class CheckUserEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String userName;
  final String password;
  const LoginEvent(this.userName, this.password);
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String name;
  RegisterEvent(this.username, this.password, this.email, this.name);
}

class LogoutEvent extends AuthEvent {}
