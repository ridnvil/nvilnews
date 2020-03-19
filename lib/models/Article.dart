class Articles {
  final Map source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Articles({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  factory Articles.fromJson(Map<String, dynamic> json){
    return Articles(
      source: json['source'],
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content']
    );
  }
}

class API {
  final String status;
  final int totalResult;
  final List articles;

  API({this.status, this.totalResult, this.articles});

  factory API.fromJson(Map<String, dynamic> json){
    return API(
      status: json['status'],
      totalResult: json['totalResult'],
      articles: json['articles']
    );
  } 
}