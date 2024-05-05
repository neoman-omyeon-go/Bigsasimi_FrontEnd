import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/news.dart';
import 'providers/news_providers.dart';

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
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: news.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              // 첫 번째 아이템은 메인 기사로 표시
              return _buildMainArticle(news[index]);
            } else {
              // 그 외의 아이템은 일반 기사로 표시
              return _buildRegularArticle(news[index]);
            }
          }),
    );
  }

  Widget _buildMainArticle(News article) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            article.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          CachedNetworkImage(
            imageUrl: article.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 8),
          Text(
            article.content,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegularArticle(News article) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          CachedNetworkImage(
            imageUrl: article.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 8),
          Text(
            article.content.length > 70
                ? '${article.content.substring(0, 70)}...'
                : article.content,
          ),
        ],
      ),
    );
  }
}
