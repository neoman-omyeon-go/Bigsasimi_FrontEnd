import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/news.dart';
import 'providers/news_providers.dart';
import 'news_detail_screen.dart';

class TodaysNews extends StatefulWidget {
  const TodaysNews({Key? key}) : super(key: key);

  @override
  State<TodaysNews> createState() => _TodaysNewsScreenState();
}

class _TodaysNewsScreenState extends State<TodaysNews> {
  List<News> news = [];
  bool isLoading = true;
  NewsProviders newsProvider = NewsProviders();

  Future<void> initNews() async {
    news = await newsProvider.getNews();
  }

  @override
  void initState() {
    super.initState();
    initNews().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('Today\'s Healthy News :)'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return index == 0 ? _buildMainArticle(news[index]) : _buildRegularArticle(news[index]);
        },
      ),
    );
  }

  Widget _buildMainArticle(News article) {
    return GestureDetector(
      onTap: () {
        _navigateToArticleUrl(article);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: article.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 8),
            Text(
              article.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularArticle(News article) {
    return GestureDetector(
      onTap: () {
        _navigateToArticleUrl(article);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: article.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 8),
            Text(
              article.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNewsDetail(News article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)),
    );
  }

  void _navigateToArticleUrl(News article) async {
    Uri uri = Uri.parse(article.url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch ${article.url}';
    }
  }

// void _navigateToNewsDetail(News article) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)),
  //   );
  // }

}
