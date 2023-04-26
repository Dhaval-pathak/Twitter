class Tweet {
  final String id;
  final String author;
  final String content;

  Tweet({
    required this.id,
    required this.author,
    required this.content,
  });

  factory Tweet.fromFirestore(Map<String, dynamic> data, String documentId) {
    final String author = data['author'];
    final String content = data['content'];

    return Tweet(
      id: documentId,
      author: author,
      content: content,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'author': author,
      'content': content,
    };
  }
}