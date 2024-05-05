class News {
  late String title;
  late String content;
  late String imageUrl;
  late String url;

  News({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.url,
  });

  News.fromMap(Map<String, dynamic>? map) {
    title = map?['title'] ?? '';
    content = map?['description'] ?? '';
    imageUrl = map?['imageUrl'] ?? '';
    url = map?['url'] ?? '';
  }
}
