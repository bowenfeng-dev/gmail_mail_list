import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_mail_list/blocs/blocs.dart';

class AccountButton extends StatefulWidget {
  @override
  _AccountButtonState createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = BlocProvider.of<SignInBloc>(context);
    return BlocBuilder(
      bloc: signInBloc,
      builder: (_, state) {
        if (state is SignedIn) {
          return IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signInBloc.dispatch(DoSignOut()),
          );
        }
        if (state is SignedOut) {
          return IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => signInBloc.dispatch(DoSignIn()),
          );
        }
        return IconButton(icon: Icon(Icons.account_circle));
      },
    );
  }
}
