import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';

abstract class SignInEvent extends Equatable {}

class DoSignIn extends SignInEvent {}

class DoSignOut extends SignInEvent {}

abstract class SignInState extends Equatable {}

class SignedOut extends SignInState {
  @override
  String toString() => 'SignedOut';
}

class SigningIn extends SignInState {
  @override
  String toString() => 'SigningIn';
}

class SigningOut extends SignInState {
  @override
  String toString() => 'SigningOut';
}

class SignedIn extends SignInState {
  @override
  String toString() => 'SignedIn';
}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', GmailApi.MailGoogleComScope],
  );

  GoogleSignInAccount account;

  String get userId => account?.email ?? '';

  @override
  SignInState get initialState => SignedOut();

  @override
  Stream<SignInState> mapEventToState(
      SignInState currentState, SignInEvent event) async* {
    if (event is DoSignIn && currentState is SignedOut) {
      yield SigningIn();
      try {
        account = await _googleSignIn.signIn();
        if (account == null) {
          yield SignedOut();
        } else {
          yield SignedIn();
        }
      } catch (error) {
        print(error);
        yield SignedOut();
      }
    }

    if (event is DoSignOut && currentState is SignedIn) {
      yield SigningOut();
      account = null;
      await _googleSignIn.signOut();
      yield SignedOut();
    }
  }
}
