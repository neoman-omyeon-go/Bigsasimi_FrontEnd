class News {
  late String title;
  late String content;
  late String imageUrl;
  late String url;
  late Map<String, dynamic>? source;
  late String name;

  News({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.url,
  });

  News.fromMap(Map<String, dynamic>? map) {
    title = map?['title'] ?? '';
    content = map?['description'] ?? '';
    imageUrl = map?['urlToImage'] ?? '';
    url = map?['url'] ?? '';
    source = map?['source']??'';
    name = map?['name']??'';
  }
}
