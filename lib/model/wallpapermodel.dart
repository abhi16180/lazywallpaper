class WallPaperModel {
  final String? previewURL;
  final String? largeImageURL;
  final int? views;
  final int? likes;
  final int? downloads;
  final int? id;

  WallPaperModel({
    this.id,
    this.previewURL,
    this.largeImageURL,
    this.views,
    this.likes,
    this.downloads,
  });

  factory WallPaperModel.fromJson(Map<String, dynamic> json) {
    return WallPaperModel(
      id: json['id'],
      previewURL: json['webformatURL'],
      largeImageURL: json['largeImageURL'],
      views: json['views'],
      likes: json['likes'],
      downloads: json['downloads'],
    );
  }
}
