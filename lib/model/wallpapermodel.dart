class WallPaperModel {
  final int? id;
  final String? previewURL;
  final String? largeImageURL;

  WallPaperModel({this.id, this.previewURL, this.largeImageURL});

  factory WallPaperModel.fromJson(Map<String, dynamic> json) {
    return WallPaperModel(
        id: json['id'],
        previewURL: json['webformatURL'],
        largeImageURL: json['largeImageURL']);
  }
}
