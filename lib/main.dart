import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gmail_mail_list/blocs/blocs.dart';
import 'package:gmail_mail_list/pages/pages.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SignInBloc _signInBloc = SignInBloc();

  @override
  void initState() {
    _signInBloc.dispatch(DoSignIn());
    super.initState();
  }

  @override
  void dispose() {
    _signInBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      bloc: _signInBloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(title: 'Flutter Gmail'),
      ),
    );
  }
}
