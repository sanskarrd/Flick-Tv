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
      showControlsOnInitialize: false,
      hideControlsTimer: const Duration(seconds: 3),
      controlsSafeAreaMinimum: const EdgeInsets.only(
        top: 80, // Space for back button and title
        bottom: 60,
        left: 20,
        right: 20,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFE50914),
        handleColor: const Color(0xFFE50914),
        backgroundColor: const Color(0xFF404040),
        bufferedColor: const Color(0xFF666666),
      ),
      // Use default controls for now - will enhance later
      // customControls: const NetflixControls(),
      errorBuilder: (context, errorMessage) => Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFE50914),
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'Unable to play video',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Go Back'),
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

              // Netflix-style overlay with back button and video info
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).padding.top + 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          // Back button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 24),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Video title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  video.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_currentIndex + 1} of ${widget.videos.length}',
                                  style: const TextStyle(
                                    color: Color(0xFFB3B3B3),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // More options button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white, size: 24),
                              onPressed: () {
                                // TODO: Show more options
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
