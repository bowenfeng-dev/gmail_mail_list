import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_mail_list/blocs/blocs.dart';
import 'package:gmail_mail_list/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GmailBloc gmailBloc = GmailBloc();

  @override
  void dispose() {
    gmailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = BlocProvider.of<SignInBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[AccountButton()],
      ),
      body: BlocBuilder(
        bloc: signInBloc,
        builder: (BuildContext context, state) {
          if (state is SignedOut) {
            return Text('Please sign in');
          }
          if (state is SignedIn) {
            return BlocBuilder(
              bloc: gmailBloc,
              builder: (BuildContext context, state) {
                if (state is GmailUninitialized) {
                  gmailBloc.dispatch(FetchThreads(signInBloc: signInBloc));
                  return Text('Loading');
                }
                if (state is GmailThreadLoaded) {
                  return ListView.builder(
                    itemCount: state.threads.length,
                    itemBuilder: (context, index) =>
                        ThreadListTile(thread: state.threads[index]),
                  );
                }
                return Text(state.toString());
              },
            );
          }
          return Text(state.toString());
        },
      ),
    );
  }
}
