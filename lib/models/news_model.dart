class NewsModel {

  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String content;
  final String articleUrl;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.articleUrl,
  });

  factory NewsModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return NewsModel(

      title:
      json["title"] ??
          "No Title",

      description:
      json["description"] ??
          "No Description",

      imageUrl:
      json["image_url"] ??
          "",

      source:
      json["source_name"] ??
          "Unknown",

      publishedAt:
      json["pubDate"] ??
          "",

      content:
      json["content"] ??
          "",

      articleUrl:
      json["link"] ??
          "",
    );
  }
}