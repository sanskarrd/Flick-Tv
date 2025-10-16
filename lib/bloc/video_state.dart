import 'package:equatable/equatable.dart';
import '../models/video_item.dart';

abstract class VideoState extends Equatable {
  const VideoState();
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<List<VideoItem>> categories;
  const VideoLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class VideoError extends VideoState {
  final String message;
  const VideoError(this.message);
  @override
  List<Object?> get props => [message];
}
