class ThreadSummary {
  String from;
  String avatarUrl;
  String subject;
  String snippet;
  List<String> attachments;

  ThreadSummary(
      {this.from,
      this.avatarUrl,
      this.subject,
      this.snippet,
      this.attachments});

  @override
  String toString() {
    return 'Thread{'
        'from:$from, '
        'subject:$subject, '
        'snippet:$snippet, '
        'avatar:$avatarUrl, '
        'attachments:$attachments}';
  }
}
