import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_mail_list/blocs/blocs.dart';
import 'package:gmail_mail_list/models/models.dart';
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
        actions: <Widget>[
          AccountButton(),
        ],
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
                  gmailBloc.dispatch(
                    FetchThreads(
                        gmailApi: signInBloc.gmailApi,
                        userId: signInBloc.userId),
                  );
                  return Text('Loading');
                }
                if (state is GmailThreadLoaded) {
                  return ListView.builder(
                    itemCount: state.threads.length,
                    itemBuilder: (context, index) {
                      EmailThread thread = state.threads[index];
                      return Text(
                          'Thread with ${thread.messages.length} messages');
                    },
                  );
                }
                return Text(state.toString());
              },
            );
          }
          return Text(state.toString());
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//  void _onSignedIn(GoogleSignInAccount account) async {
//    _currentAccount = account;
//    print(_currentAccount.id);
//
//    final gmail = await _gmailApi();
//    gmail.users.threads.list(_userId).then(_onThreadListFetched);
//  }
//
//  Future<GmailApi> _gmailApi() async {
//    final authHeaders = await _currentAccount.authHeaders;
//    final client = GoogleHttpClient(authHeaders);
//    return GmailApi(client);
//  }
//
//  String get _userId => _currentAccount?.email ?? '';
//
//  void _onThreadListFetched(ListThreadsResponse response) async {
//    final threads = response.threads;
//    print('${threads.length} threads fetched');
//    print(threads.map((thread) => thread.id).toList());
//    print(threads.map((thread) => thread.snippet).toList());
//    final gmail = await _gmailApi();
//    gmail.users.threads.get(_userId, threads.first.id).then(_onThreadFetched);
//  }
//
//  void _onThreadFetched(Thread thread) {
//    print(thread);
//    print('${thread.messages.length} messages in thread');
//    final message = thread.messages.first;
//    final base64Url = const Base64Codec.urlSafe();
//
//    var parts = Map.fromIterable(message.payload.parts,
//        key: (part) => part.mimeType,
//        value: (part) =>
//            String.fromCharCodes(base64Url.decode(part.body.data)));
//
//    print(parts.length);
//    parts.forEach((mimeType, body) => print('$mimeType: $body'));
//  }
}
