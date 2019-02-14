import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:gmail_mail_list/ThreadSummary.dart';

class DetailScreen extends StatelessWidget {
  final ThreadSummary thread;

  DetailScreen({Key key, @required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(thread.subject)),
      body: ListView.builder(
        itemBuilder: _buildOneMessage,
        itemCount: thread.senders.length,
      ),
    );
  }

  Widget _buildOneMessage(BuildContext context, int index) {
    final sender = thread.senders[index];
    return ExpansionTile(
      title: Text(sender),
      children: <Widget>[
        Row(children: <Widget>[Text(lorem(paragraphs: 3, words: 15))]),
      ],
    );
  }
}
