import 'package:flutter/material.dart';
import 'package:gmail_mail_list/models/models.dart';

class ThreadListTile extends StatelessWidget {
  final EmailThread thread;

  const ThreadListTile({Key key, this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(thread),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.messages.map((message) => message.from).join(', '),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    thread.subject,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    thread.snippet,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildAttachmentButtons(thread),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatar(EmailThread thread) {
    return CircleAvatar(
      child: Text(thread.messages.last.from[0]),
    );
  }

  Widget _buildAttachmentButtons(EmailThread thread) {
    var attachments = thread.messages.expand((m) => m.attachments);
    return attachments.isEmpty
        ? Row()
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: attachments.map(_buildOneAttachmentButton).toList(),
        ),
      ),
    );
  }

  Widget _buildOneAttachmentButton(EmailAttachment attachment) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlineButton(
        child: Text(attachment.filename),
        onPressed: () {},
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
