import '../models/video_item.dart';
import '../services/api_service.dart';

class LocalRepository {
  final ApiService _apiService = ApiService();

  Future<List<List<VideoItem>>> loadCategories() async {
    return await _apiService.fetchCategories();
  }
}
