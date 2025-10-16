import 'package:equatable/equatable.dart';

class VideoItem extends Equatable {
  final String id;
  final String title;
  final String thumbnail;
  final String videoUrl;

  const VideoItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      videoUrl: json['video_url'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, thumbnail, videoUrl];
}
