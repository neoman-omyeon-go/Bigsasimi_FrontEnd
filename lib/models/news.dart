class News {
  late String title;
  late String content;
  late String imageUrl; // imageUrl 필드 추가

  News({
    required this.title,
    required this.content,
    required this.imageUrl, // imageUrl 필드 추가
  });

  News.fromMap(Map<String, dynamic>? map) {
    title = map?['title'] ?? '';
    content = map?['description'] ?? '';
    imageUrl = map?['urlToImage'] ?? ''; // imageUrl 설정
  }
}
