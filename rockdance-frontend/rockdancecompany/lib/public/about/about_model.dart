class AboutItem {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime? createdAt;

  AboutItem({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.createdAt,
  });

  factory AboutItem.fromJson(Map<String, dynamic> j) {
    return AboutItem(
      id: j['id'] is int ? j['id'] : int.parse('${j['id']}'),
      title: j['title'] ?? '',
      body: j['body'] ?? '',
      imageUrl: j['image_url'],
      createdAt: j['created_at'] != null
          ? DateTime.tryParse('${j['created_at']}')
          : null,
    );
  }
}
