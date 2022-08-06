import 'dart:convert';
import 'package:flutter/material.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  String status;
  int totalResults;
  List<Article> articles;

  News({
    @required this.status,
    @required this.totalResults,
    @required this.articles,
  });

  factory News.fromJson(Map<String, dynamic> json) => new News(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: new List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": new List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  Article({
    @required this.source,
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.urlToImage,
    @required this.publishedAt,
    @required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => new Article(
    source: Source.fromJson(json["source"]),
    author: json["author"] == null ? null : json["author"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    content: json["content"] == null ? null : json["content"],
  );

  Map<String, dynamic> toJson() => {
    "source": source.toJson(),
    "author": author == null ? null : author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "content": content == null ? null : content,
  };
}

class Source {
  String id;
  String name;

  Source({
    @required this.id,
    @required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => new Source(
    id: json["id"] == null ? null : json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name,
  };
}
