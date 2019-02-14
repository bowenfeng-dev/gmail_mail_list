class ThreadSummary {
  List<String> senders;
  String avatarUrl;
  String subject;
  String snippet;
  List<String> attachments;

  ThreadSummary(
      {this.senders,
      this.avatarUrl,
      this.subject,
      this.snippet,
      this.attachments});

  @override
  String toString() {
    return 'Thread{'
        'from:$senders, '
        'subject:$subject, '
        'snippet:$snippet, '
        'avatar:$avatarUrl, '
        'attachments:$attachments}';
  }
}
