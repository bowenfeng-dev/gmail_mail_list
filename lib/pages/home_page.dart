import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmail_mail_list/ThreadSummary.dart';
import 'package:gmail_mail_list/google_http_client.dart';
import 'package:gmail_mail_list/pages/thread_detail_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_user/models.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:random_user/random_user.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:quiver/iterables.dart' show partition;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _refreshController = RefreshController();
  GoogleSignInAccount _currentAccount;

  final _threadsStreamController = StreamController<List<ThreadSummary>>();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', GmailApi.MailGoogleComScope],
  );

  @override
  void dispose() {
    _threadsStreamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    RandomUser().getUsers(results: 70).then((users) {
      _threadsStreamController.sink
          .add(partition(users, 5).map(_toThreadSummary).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ThreadSummary>>(
        stream: _threadsStreamController.stream,
        initialData: [],
        builder: _buildThreadsList,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: _handleSignIn,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onPullToRefresh(bool up) {
    print('_onPullToRefresh $up');
    Future.delayed(Duration(milliseconds: 2000))
        .then((_) => _refreshController.sendBack(up, RefreshStatus.completed));
  }

  Widget _refresherHeaderBuilder(BuildContext context, int mode) {
    return ClassicIndicator(
      mode: mode,
      idleText: '',
      releaseText: '',
      refreshingText: '',
      completeText: '',
      completeIcon: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
      idleIcon: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
      releaseIcon: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    );
  }

  SizedBox _buildAvatar(String avatarUrl) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: ClipOval(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: avatarUrl,
        ),
      ),
    );
  }

  Widget _buildAttachmentButtons(List<String> attachments) {
    return attachments == null
        ? Row()
        : Row(children: attachments.map(_buildAttachmentButton).toList());
  }

  Widget _buildAttachmentButton(String attachment) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlineButton(
        child: Text(attachment),
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  ThreadSummary _toThreadSummary(List<dynamic> users) {
    final senders = users.cast<User>();
    return ThreadSummary(
      senders: senders.map((sender) => sender.name.first).toList(),
      avatarUrl: senders.last.picture.thumbnail,
      subject: lorem(paragraphs: 1, words: 8),
      snippet: lorem(paragraphs: 1, words: 10),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then(_onSignedIn);
    } catch (error) {
      print(error);
    }
  }

  void _onSignedIn(GoogleSignInAccount account) async {
    _currentAccount = account;
    print(_currentAccount.id);

    final gmail = await _gmailApi();
    gmail.users.threads.list(_userId).then(_onThreadListFetched);
  }

  Future<GmailApi> _gmailApi() async {
    final authHeaders = await _currentAccount.authHeaders;
    final client = GoogleHttpClient(authHeaders);
    return GmailApi(client);
  }

  String get _userId => _currentAccount == null ? '' : _currentAccount.email;

  void _onThreadListFetched(ListThreadsResponse response) async {
    final threads = response.threads;
    print('${threads.length} threads fetched');
    print(threads.map((thread) => thread.id).toList());
    print(threads.map((thread) => thread.snippet).toList());
    final gmail = await _gmailApi();
    gmail.users.threads.get(_userId, threads.first.id).then(_onThreadFetched);
  }

  void _onThreadFetched(Thread thread) {
    print(thread);
    print('${thread.messages.length} messages in thread');
    final message = thread.messages.first;
    final base64Url = const Base64Codec.urlSafe();

    var parts = Map.fromIterable(message.payload.parts,
        key: (part) => part.mimeType,
        value: (part) =>
            String.fromCharCodes(base64Url.decode(part.body.data)));

    print(parts.length);
    parts.forEach((mimeType, body) => print('$mimeType: $body'));
  }

  Widget _buildThreadsList(
      BuildContext context, AsyncSnapshot<List<ThreadSummary>> snapshot) {
    final threads = snapshot.data;
    return SmartRefresher(
      enablePullDown: true,
      headerBuilder: _refresherHeaderBuilder,
      controller: _refreshController,
      onRefresh: _onPullToRefresh,
      child: ListView.builder(
        itemBuilder: _threadItemBuilderFor(threads),
        itemCount: threads.length,
      ),
    );
  }

  IndexedWidgetBuilder _threadItemBuilderFor(List<ThreadSummary> threads) =>
      (BuildContext context, int index) {
        final thread = threads[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(thread: thread),
                ));
          },
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildAvatar(thread.avatarUrl),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            thread.senders.join(','),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(thread.subject, overflow: TextOverflow.ellipsis),
                          Text(thread.snippet, overflow: TextOverflow.ellipsis),
                          _buildAttachmentButtons(thread.attachments),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      };
}
