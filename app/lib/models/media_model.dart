class MediaModel {
  final String id;
  final String url;
  final String thumbnailUrl;
  final String? caption;
  final MediaType type;
  final String username;
  final String? profilePicUrl;
  final bool isPrivate;
  final List<String>? childrenUrls; // For carousels

  MediaModel({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    this.caption,
    required this.type,
    required this.username,
    this.profilePicUrl, 
    this.isPrivate = false,
    this.childrenUrls,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnail'] ?? '',
      caption: json['caption'],
      type: _parseType(json['type']),
      username: json['username'] ?? 'Unknown',
      profilePicUrl: json['profile_pic'],
      isPrivate: json['is_private'] ?? false,
      childrenUrls: json['children'] != null ? List<String>.from(json['children']) : null,
    );
  }

  static MediaType _parseType(String? type) {
    switch (type) {
      case 'video':
        return MediaType.video;
      case 'image':
        return MediaType.image;
      case 'carousel':
        return MediaType.carousel;
      default:
        return MediaType.image;
    }
  }
}

enum MediaType { image, video, carousel }
