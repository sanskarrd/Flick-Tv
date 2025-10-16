import 'package:flutter_bloc/flutter_bloc.dart';
import 'video_event.dart';
import 'video_state.dart';
import '../repository/local_repository.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final LocalRepository repository;
  VideoBloc({required this.repository}) : super(VideoInitial()) {
    on<LoadVideos>(_onLoad);
  }

  Future<void> _onLoad(LoadVideos event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    try {
      final categories = await repository.loadCategories();
      emit(VideoLoaded(categories));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
