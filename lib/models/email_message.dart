import 'package:googleapis/gmail/v1.dart';
import 'package:gmail_mail_list/models/models.dart';

class EmailMessage {
  final String id;
  final Map<String, String> headers;
  final List<String> labels;
  final List<EmailAttachment> attachments;
  final String planTextBody;
  final String htmlBody;

  EmailMessage.fromMessage(Message message)
      : id = message.id,
        labels = message.labelIds,
        attachments = _extractAttachments(message.payload.parts),
        headers = _extractHeaders(message),
        planTextBody = _extractBody(message, 'text/plain'),
        htmlBody = _extractBody(message, 'text/html');

  String get subject => headers['subject'];

  String get from => headers['from'];

  bool get isUnread => labels.contains('UNREAD');

  static Map<String, String> _extractHeaders(Message message) =>
      Map.fromIterable(
        message.payload.headers,
        key: (header) => header.name.toLowerCase(),
        value: (header) => header.value,
      );

  static List<EmailAttachment> _extractAttachments(List<MessagePart> parts) =>
      parts
          .where((part) => part.filename.isNotEmpty)
          .map((part) => EmailAttachment.fromMessagePart(part))
          .toList();

  static String _extractBody(Message message, String mimeType) =>
      _parseMessageBody(message.payload.parts
          .where((part) => part.mimeType == mimeType)
          .first);

  static String _parseMessageBody(MessagePart part) =>
      String.fromCharCodes(part?.body?.dataAsBytes ?? []);
}
