import 'package:flutter/material.dart';
import 'package:gmail_mail_list/ThreadSummary.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _refreshController = RefreshController();
  var _threads = [
    ThreadSummary(
        from: "hi@example.com",
        avatarUrl: "https://randomuser.me/api/portraits/thumb/men/92.jpg",
        subject: "Flutter on desktop, a real competitor to Electron",
        snippet: "Flutter desktop for real-world applications and to…",
        attachments: ["image.jpg", "code.zip", "doc.pdf"]),
    ThreadSummary(
        from: "test@flutter.io",
        avatarUrl: "https://randomuser.me/api/portraits/thumb/women/94.jpg",
        subject: "Flutter Layout Cheat Sheet",
        snippet: "Do you need simple layout samples for Flutter? …"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        headerBuilder: _refresherHeaderBuilder,
        controller: _refreshController,
        onRefresh: _onPullToRefresh,
        child: ListView.builder(
          itemBuilder: _mailItemBuilder,
          itemCount: _threads.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _mailItemBuilder(BuildContext context, int index) {
    final thread = _threads[index];
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatar(thread.avatarUrl),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(thread.from),
                  Text(thread.subject),
                  Text(thread.snippet),
                  _buildAttachmentButtons(thread.attachments),
                ],
              ),
            ),
          ],
        ));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
