import 'dart:convert';
import 'package:capstone/models/news.dart';
import 'package:http/http.dart' as http;

class NewsProviders{
  Uri uri = Uri.parse("https://newsapi.org/v2/top-headlines?country=kr&category=health&apiKey=867e6d19a10544d094de0c7af7517f93");

  Future<List<News>> getNews() async {
    List<News> news = [];

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      news = jsonDecode(response.body)['articles'].map<News>( (article) {
        return News.fromMap(article);
      }).toList();
    }

    return news;
  }


}