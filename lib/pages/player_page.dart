import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/video_item.dart';

class PlayerPage extends StatefulWidget {
  final List<VideoItem> videos;
  final int initialIndex;

  const PlayerPage({Key? key, required this.videos, required this.initialIndex})
      : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late PageController _pageController;
  late int _currentIndex;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideo(_currentIndex);
  }

  /// Initializes video for the given index
  Future<void> _initializeVideo(int index) async {
    await _disposeControllers();

    final video = widget.videos[index];
    final url = video.videoUrl;

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(seconds: 4),
      controlsSafeAreaMinimum: const EdgeInsets.only(
        top: 60, // Space for back button
        bottom: 40,
        left: 16,
        right: 16,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFE50914),
        handleColor: const Color(0xFFE50914),
        backgroundColor: const Color(0xFF1A1A1C),
        bufferedColor: const Color(0xFF666666),
      ),
      errorBuilder: (context, errorMessage) => Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFE50914),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to play video',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    setState(() {});
  }

  /// Properly disposes of controllers to prevent memory leaks
  Future<void> _disposeControllers() async {
    try {
      _chewieController?.pause();
      _videoController?.pause();
      _chewieController?.dispose();
      _videoController?.dispose();
    } catch (_) {}
    _chewieController = null;
    _videoController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.videos.length,
        onPageChanged: (index) {
          _currentIndex = index;
          _initializeVideo(index);
        },
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          final isCurrent = index == _currentIndex;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Video Player - Always show video, no thumbnail fallback
              if (_chewieController != null && isCurrent)
                Chewie(controller: _chewieController!)
              else
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE50914),
                    ),
                  ),
                ),

              // Back button overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
