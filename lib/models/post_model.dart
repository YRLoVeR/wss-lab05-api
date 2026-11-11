class PostModal {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostModal({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModal.fromJson(Map<String, dynamic> json) {
    return PostModal(
      userId: int.tryParse(json['userId']?.toString() ?? '') ?? 0,
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      title: json['title'] as String? ?? 'Untitled Post',
      body: json['body'] as String? ?? 'No content available.',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }
}
