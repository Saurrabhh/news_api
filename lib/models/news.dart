import 'dart:convert';
import 'package:hive/hive.dart';
part 'news.g.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class News{
  @HiveField(0)
  String source;

  @HiveField(1)
  String author;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  String url;

  @HiveField(5)
  String urlToImage;

  @HiveField(6)
  DateTime publishedAt;

  @HiveField(7)
  String content;

  News(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  factory News.fromJson(Map<String, dynamic> json) => News(
    source: json["source"]["name"] ?? "",
    author: json["author"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    url: json["url"] ?? "",
    urlToImage: json["urlToImage"] ?? "",
    publishedAt: DateTime.parse(json["publishedAt"]),
    content: json["content"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "content": content,
  };
}