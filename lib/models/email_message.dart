import 'package:googleapis/gmail/v1.dart';
import 'package:gmail_mail_list/models/models.dart';
import 'package:meta/meta.dart';

class EmailMessage {
  final String id;
  final Map<String, String> headers;
  final List<String> labels;
  final List<EmailAttachment> attachments;
  final String planTextBody;
  final String htmlBody;

  EmailMessage._({
    @required this.id,
    @required this.headers,
    @required this.labels,
    @required this.planTextBody,
    @required this.htmlBody,
    @required this.attachments,
  });

  factory EmailMessage(Message message) {
    var messageParts = _extractLeafParts(message.payload).toList();
    print('processing message ${message.id} "${message.snippet}"');
    print('  - messageParts: $messageParts');
    return EmailMessage._(
      id: message.id,
      headers: _extractHeaders(message),
      labels: message.labelIds,
      planTextBody: _parseMessageBody(messageParts, 'text/plain'),
      htmlBody: _parseMessageBody(messageParts, 'text/html'),
      attachments: _parseAttachments(messageParts),
    );
  }

  String get subject => headers['subject'];

  String get from => headers['from'];

  bool get isUnread => labels.contains('UNREAD');

  static Map<String, String> _extractHeaders(Message message) {
    print('  - extract headers');
    return Map.fromIterable(
      message.payload.headers,
      key: (header) => header.name.toLowerCase(),
      value: (header) => header.value,
    );
  }

  static String _parseMessageBody(List<MessagePart> parts, String mimeType) {
    print('  - parse body $mimeType');
    return String.fromCharCodes(
        _findMessageBodyByMimeType(parts, mimeType) ?? []);
  }

  static List<int> _findMessageBodyByMimeType(
      List<MessagePart> parts, String mimeType) {
    return parts
        .firstWhere(_isMessageWithMimeType(mimeType), orElse: () => null)
        ?.body
        ?.dataAsBytes;
  }

  static bool Function(MessagePart) _isMessageWithMimeType(String mimeType) {
    return (part) => _hasSameMimeType(part, mimeType) && !_hasFilename(part);
  }

  static bool _hasSameMimeType(MessagePart part, String mimeType) {
    return part.mimeType.toLowerCase() == mimeType.toLowerCase();
  }

  static bool _hasFilename(MessagePart part) {
    return part.filename != null && part.filename.isNotEmpty;
  }

  static Iterable<MessagePart> _extractLeafParts(MessagePart part) {
    if (part.parts == null) {
      return [part];
    }
    return part.parts.expand((childPart) => _extractLeafParts(childPart));
  }

  static List<EmailAttachment> _parseAttachments(
      List<MessagePart> messageParts) {
    print('  - parse attachments');
    return messageParts
        .where(_hasFilename)
        .map((part) => EmailAttachment.fromMessagePart(part))
        .toList();
  }
}
