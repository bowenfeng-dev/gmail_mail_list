import 'package:googleapis/gmail/v1.dart';
import 'package:gmail_mail_list/models/models.dart';

class EmailThread {
  final Thread thread;
  final List<EmailMessage> _messages;

  EmailThread.fromThread(this.thread) : _messages = _extractMessages(thread);

  String get id => thread.id;

  String get snippet => thread.snippet;

  String get subject => _messages.first.subject;

  Iterable<String> get readSenders =>
      _messages.where((m) => !m.isUnread).map((m) => m.from);

  Iterable<String> get unreadSenders =>_messages.where((m) => !m.isUnread).map((m) => m.from);

  List<EmailMessage> get messages => _messages;

  @override
  String toString() {
    return 'Thread{'
        'id:$id, '
        'subject:$subject, '
        'snippet:$snippet}';
  }

  static List<EmailMessage> _extractMessages(Thread thread) =>
      thread.messages.map((m) => EmailMessage(m)).toList();
}
