import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/video_item.dart';
import '../util/strings.dart';

class CustomVideoPlayer extends StatefulWidget {
  final VideoItem video;
  final VoidCallback? onBack;
  final String? videoPosition;

  const CustomVideoPlayer({
    Key? key,
    required this.video,
    this.onBack,
    this.videoPosition,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isFullscreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  // Timer for hiding controls
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    ));
    _controlsAnimationController.forward();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );

      await _controller!.initialize();

      _controller!.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
        _totalDuration = _controller!.value.duration;
        _isPlaying = _controller!.value.isPlaying;
      });

      // Auto-play the video
      _controller!.play();
      _startHideControlsTimer();
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _videoListener() {
    if (!mounted) return;

    final value = _controller!.value;
    setState(() {
      _currentPosition = value.position;
      _isPlaying = value.isPlaying;
      _isBuffering = value.isBuffering;
    });
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
    _showControlsTemporarily();
  }

  void _seekTo(Duration position) {
    if (_controller == null) return;
    _controller!.seekTo(position);
    _showControlsTemporarily();
  }

  void _seekForward() {
    if (_controller == null) return;
    final newPosition = _currentPosition + const Duration(seconds: 10);
    final clampedPosition =
        newPosition > _totalDuration ? _totalDuration : newPosition;
    _seekTo(clampedPosition);
  }

  void _seekBackward() {
    if (_controller == null) return;
    final newPosition = _currentPosition - const Duration(seconds: 10);
    final clampedPosition =
        newPosition < Duration.zero ? Duration.zero : newPosition;
    _seekTo(clampedPosition);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    // Force show controls after orientation change and rebuild UI
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _forceShowControls();
        _showControlsTemporarily();
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        _hideControls();
      }
    });
  }

  void _hideControls() {
    _controlsAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onTap() {
    if (_showControls) {
      _hideControls();
    } else {
      _showControlsTemporarily();
    }
  }

  void _forceShowControls() {
    _hideControlsTimer?.cancel();
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controlsAnimationController.dispose();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();

    // Reset system UI when leaving
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE50914),
          ),
        ),
      );
    }

    // Ensure controls are visible after orientation changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isFullscreen !=
          (MediaQuery.of(context).orientation == Orientation.landscape)) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _forceShowControls();
          }
        });
      }
    });

    return GestureDetector(
      onTap: _onTap,
      onDoubleTap: _togglePlayPause,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),

            // Loading indicator when buffering
            if (_isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE50914),
                ),
              ),

            // Controls overlay
            if (_showControls)
              AnimatedBuilder(
                animation: _controlsAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controlsAnimation.value,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top controls
                          SafeArea(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Back button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: widget.onBack,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Video title
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.video.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (widget.videoPosition != null &&
                                            widget.videoPosition!.isNotEmpty)
                                          Text(
                                            widget.videoPosition!,
                                            style: const TextStyle(
                                              color: Color(0xFFB3B3B3),
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Fullscreen toggle
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isFullscreen
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: _toggleFullscreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Center play/pause controls
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Seek backward
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.replay_10,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: _seekBackward,
                                    ),
                                  ),

                                  const SizedBox(width: 40),

                                  // Play/Pause
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: IconButton(
                                      iconSize: 48,
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                      onPressed: _togglePlayPause,
                                    ),
                                  ),

                                  const SizedBox(width: 40),

                                  // Seek forward
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.forward_10,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: _seekForward,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom controls
                          SafeArea(
                            child: Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.all(_isFullscreen ? 24.0 : 16.0),
                              child: Column(
                                children: [
                                  // Progress bar
                                  Row(
                                    children: [
                                      Text(
                                        _formatDuration(_currentPosition),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor:
                                                const Color(0xFFE50914),
                                            inactiveTrackColor:
                                                const Color(0xFF404040),
                                            thumbColor: const Color(0xFFE50914),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                              enabledThumbRadius: 6,
                                            ),
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                              overlayRadius: 12,
                                            ),
                                            trackHeight: 3,
                                          ),
                                          child: Slider(
                                            value:
                                                _totalDuration.inMilliseconds >
                                                        0
                                                    ? _currentPosition
                                                        .inMilliseconds
                                                        .toDouble()
                                                    : 0.0,
                                            min: 0.0,
                                            max: _totalDuration.inMilliseconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              _seekTo(Duration(
                                                  milliseconds: value.toInt()));
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatDuration(_totalDuration),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
