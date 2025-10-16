import 'package:flutter/material.dart';
import '../models/video_item.dart';
import '../widgets/custom_video_player.dart';

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
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
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          final isCurrent = index == _currentIndex;

          return isCurrent
              ? CustomVideoPlayer(
                  video: video,
                  onBack: () => Navigator.of(context).pop(),
                  videoPosition:
                      '${_currentIndex + 1} of ${widget.videos.length}',
                )
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE50914),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
