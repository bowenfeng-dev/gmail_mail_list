import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:gmail_mail_list/ThreadSummary.dart';
import 'package:gmail_mail_list/widgets/vanilla_expansion_tile.dart';

class DetailScreen extends StatelessWidget {
  final ThreadSummary thread;

  DetailScreen({Key key, @required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(thread.subject)),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.separated(
          itemBuilder: _buildOneMessage,
          itemCount: thread.senders.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildOneMessage(BuildContext context, int index) {
    final sender = thread.senders[index];
    return VanillaExpansionTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(child: Text(sender[0])),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(sender),
            ),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
          child: Row(children: <Widget>[
            Text(lorem(paragraphs: 3, words: 15)),
          ]),
        ),
      ],
    );
  }
}
