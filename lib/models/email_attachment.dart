import 'package:googleapis/gmail/v1.dart';

class EmailAttachment {
  final String filename;
  final String mimeType;
  final String id;

  EmailAttachment.fromMessagePart(MessagePart part)
      : filename = part.filename,
        mimeType = part.mimeType,
        id = part.body.attachmentId;
}
