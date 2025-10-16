import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_item.dart';

class ApiService {
  // Sample video URLs for demo
  static const List<String> sampleVideoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
  ];

  // Sample movie data with reliable image URLs (using Picsum for guaranteed availability)
  static const List<Map<String, dynamic>> sampleMovies = [
    {
      'id': 1,
      'title': 'The Dark Knight',
      'thumbnail': 'https://picsum.photos/400/600?random=1',
    },
    {
      'id': 2,
      'title': 'Inception',
      'thumbnail': 'https://picsum.photos/400/600?random=2',
    },
    {
      'id': 3,
      'title': 'Interstellar',
      'thumbnail': 'https://picsum.photos/400/600?random=3',
    },
    {
      'id': 4,
      'title': 'The Matrix',
      'thumbnail': 'https://picsum.photos/400/600?random=4',
    },
    {
      'id': 5,
      'title': 'Blade Runner 2049',
      'thumbnail': 'https://picsum.photos/400/600?random=5',
    },
    {
      'id': 6,
      'title': 'Mad Max: Fury Road',
      'thumbnail': 'https://picsum.photos/400/600?random=6',
    },
    {
      'id': 7,
      'title': 'Dune',
      'thumbnail': 'https://picsum.photos/400/600?random=7',
    },
    {
      'id': 8,
      'title': 'Tenet',
      'thumbnail': 'https://picsum.photos/400/600?random=8',
    },
    {
      'id': 9,
      'title': 'Avatar',
      'thumbnail': 'https://picsum.photos/400/600?random=9',
    },
    {
      'id': 10,
      'title': 'Avengers',
      'thumbnail': 'https://picsum.photos/400/600?random=10',
    },
    {
      'id': 11,
      'title': 'Spider-Man',
      'thumbnail': 'https://picsum.photos/400/600?random=11',
    },
    {
      'id': 12,
      'title': 'Iron Man',
      'thumbnail': 'https://picsum.photos/400/600?random=12',
    },
    {
      'id': 13,
      'title': 'Thor',
      'thumbnail': 'https://picsum.photos/400/600?random=13',
    },
    {
      'id': 14,
      'title': 'Captain America',
      'thumbnail': 'https://picsum.photos/400/600?random=14',
    },
    {
      'id': 15,
      'title': 'Black Widow',
      'thumbnail': 'https://picsum.photos/400/600?random=15',
    },
    {
      'id': 16,
      'title': 'Doctor Strange',
      'thumbnail': 'https://picsum.photos/400/600?random=16',
    },
    {
      'id': 17,
      'title': 'Guardians of Galaxy',
      'thumbnail': 'https://picsum.photos/400/600?random=17',
    },
    {
      'id': 18,
      'title': 'Black Panther',
      'thumbnail': 'https://picsum.photos/400/600?random=18',
    },
  ];

  Future<List<List<VideoItem>>> fetchCategories() async {
    try {
      print('Starting to fetch categories...');

      // Simulate network delay for loading screen
      await Future.delayed(const Duration(seconds: 3));

      print('Generating movie categories...');

      // Generate different categories using sample data
      final List<List<VideoItem>> categories = [
        await _generateMovieCategory('trending', 0),
        await _generateMovieCategory('popular', 6),
        await _generateMovieCategory('toprated', 12),
      ];

      print(
          'Categories generated successfully: ${categories.length} categories');
      for (int i = 0; i < categories.length; i++) {
        print('Category $i has ${categories[i].length} movies');
      }

      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return _getFallbackData();
    }
  }

  Future<List<VideoItem>> _generateMovieCategory(
      String categoryType, int startIndex) async {
    print('Generating category: $categoryType starting at index $startIndex');

    // Take different movies for each category
    final categoryMovies = <VideoItem>[];

    for (int i = 0; i < 6; i++) {
      final movieIndex = (startIndex + i) % sampleMovies.length;
      final movie = sampleMovies[movieIndex];
      final videoUrl = sampleVideoUrls[movieIndex % sampleVideoUrls.length];

      final videoItem = VideoItem(
        id: '${categoryType}_${movie['id']}',
        title: movie['title'],
        thumbnail: movie['thumbnail'],
        videoUrl: videoUrl,
      );

      categoryMovies.add(videoItem);
      print(
          'Added movie: ${videoItem.title} with thumbnail: ${videoItem.thumbnail}');
    }

    // Small delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 500));

    return categoryMovies;
  }

  List<List<VideoItem>> _getFallbackData() {
    print('Using fallback data');

    // Create fallback data with simple, reliable thumbnails
    final fallbackMovies = <VideoItem>[];

    for (int i = 0; i < 18; i++) {
      fallbackMovies.add(VideoItem(
        id: 'fallback_$i',
        title: 'Movie ${i + 1}',
        thumbnail:
            'https://picsum.photos/400/600?random=${i + 100}', // Different seed for fallback
        videoUrl: sampleVideoUrls[i % sampleVideoUrls.length],
      ));
    }

    return [
      fallbackMovies.sublist(0, 6),
      fallbackMovies.sublist(6, 12),
      fallbackMovies.sublist(12, 18),
    ];
  }
}
