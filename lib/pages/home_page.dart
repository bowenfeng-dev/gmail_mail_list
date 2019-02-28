import 'package:flutter/material.dart';
import 'package:gmail_mail_list/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          AccountButton(),
        ],
      ),
      body: Container(),
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
