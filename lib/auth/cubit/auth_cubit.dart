import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  TextEditingController emailSignUpController = TextEditingController();
  TextEditingController passwordSignUpController = TextEditingController();
  TextEditingController emailSignInController = TextEditingController();
  TextEditingController passwordSignInController = TextEditingController();

  Future<void> signUp() async {
    emit(SignUpLoading());
    try {
      final data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailSignUpController.text,
        password: passwordSignUpController.text,
      );

      if (data.user == null) {
        emit(SignUpFailure("Unable to create an account"));
        return;
      }

      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpFailure('The account already exists for that email.'));
      } else {
        emit(SignUpFailure("fire auth exception"));
      }
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<void> signIn() async {
    emit(SignInLoading());
    try {
      final data = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailSignInController.text,
        password: passwordSignInController.text,
      );

      if (data.user == null) {
        emit(SignInFailure("Unable to access an account"));
        return;
      }

      await data.user!.reload();

      if (FirebaseAuth.instance.currentUser != null) {
        emit(SignInSuccess());
      } else {
        emit(EmailNotVerified());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(SignInFailure('Wrong password provided for that user.'));
      } else if (e.code == 'invalid-credential') {
        emit(SignInFailure('Email or password is incorrect'));
      } else {
        emit(SignInFailure("fire auth exception"));
      }
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }
}
