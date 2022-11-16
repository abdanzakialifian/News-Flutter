import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/widgets/card_article.dart';
import 'package:news_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';
import '../../data/model/article_result.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("News App"),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, value, child) {
        if (value.resultState == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else if (value.resultState == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: value.articleResult.articles?.length ?? 0,
            itemBuilder: (context, index) {
              var article = value.articleResult.articles?[index];
              return CardArticle(article: article as Article);
            },
          );
        } else if (value.resultState == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(value.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(""),
            ),
          );
        }
      },
    );
  }

  List<Article> parseArticles(String? json) {
    if (json == null) {
      return [];
    }

    final List parsed = jsonDecode(json);
    return parsed.map((json) => Article.fromJson(json)).toList();
  }
}
