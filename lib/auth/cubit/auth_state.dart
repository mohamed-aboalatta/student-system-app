part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {}

final class SignUpFailure extends AuthState {
  final String msg;
  SignUpFailure(this.msg);
}

final class SignInLoading extends AuthState {}

final class SignInSuccess extends AuthState {}

final class SignInFailure extends AuthState {
  final String msg;
  SignInFailure(this.msg);
}

final class EmailNotVerified extends AuthState {}

final class VerifyLoading extends AuthState {}

final class VerifySuccess extends AuthState {}

final class VerifyFailure extends AuthState {
  final String msg;
  VerifyFailure(this.msg);
}
