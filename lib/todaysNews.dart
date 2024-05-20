import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
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
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
        title: Text(
          'Today\'s Healthy News :)',
          style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w800, fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: news.isNotEmpty ? _buildMainArticle(news[0]) : SizedBox(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildRegularArticle(news[index+2]),
              childCount: news.length -1,
              //0번째 인덱스를 썼으니까(메인 기사로), 그 인덱스를 제외한 전체 길이여야 함.
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainArticle(News article) {
    return GestureDetector(
      onTap: () {
        _navigateToArticleUrl(article);
      },
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: article.imageUrl,
            height: 300,  // 높이를 300으로 조정
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w800, fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  article.content,
                  maxLines: 4,  // 본문 내용 4줄까지 표시
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w400, fontSize: 17),
                ),
              ],
            ),
          ),
        ],
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
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 19),
                  ),
                  Text(
                    article.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToArticleUrl(News article) async {
    Uri uri = Uri.parse(article.url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch ${article.url}';
    }
  }
}
