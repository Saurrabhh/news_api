import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../constants.dart';
import '../../../models/news.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.news,
  });

  final News news;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [buildInfo(), buildImage()],
          ),
        ),
      ),
    );
  }

  Expanded buildImage() {
    return Expanded(
      flex: 3,
      child: Image.network(
        news.urlToImage,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.image,
            size: 100,
            color: kSecondaryColor,
          );
        },
      ),
    );
  }

  Expanded buildInfo() {
    return Expanded(
      flex: 7,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              children: [
                Text(
                  timeago.format(DateTime.now()
                      .subtract(DateTime.now().difference(news.publishedAt))),
                  style: const TextStyle(fontSize: 11),
                ),
                addHorizontalSpace(4),
                Text(
                  news.source,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              news.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: kSecondaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              news.description,
              style: const TextStyle(fontSize: 13, color: kSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
