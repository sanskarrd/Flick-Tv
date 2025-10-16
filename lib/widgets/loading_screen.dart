import 'package:flutter/material.dart';
import 'flicktv_logo.dart';
import '../util/strings.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String _getLoadingText(double progress) {
    if (progress < 0.25) {
      return 'Connecting to FlickTV...';
    } else if (progress < 0.5) {
      return 'Loading your personalized content...';
    } else if (progress < 0.75) {
      return 'Preparing your entertainment...';
    } else if (progress < 0.95) {
      return 'Almost ready to stream...';
    } else {
      return 'Welcome to FlickTV!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414), // Netflix background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Netflix-style Animated FLICKTV Logo with custom image
            const AnimatedFlickTVLogo(fontSize: 64, showSubtitle: true),

            const SizedBox(height: 100),

            // Netflix-style Loading Animation
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _progressAnimation.value,
                  child: Column(
                    children: [
                      // Circular loading indicator
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF404040),
                                  width: 3,
                                ),
                              ),
                            ),
                            // Progress circle
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: _progressAnimation.value,
                                strokeWidth: 3,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFE50914),
                                ),
                                backgroundColor: Colors.transparent,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            // Center play icon
                            Icon(
                              Icons.play_arrow_rounded,
                              color: const Color(0xFFE50914),
                              size: 32,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Loading Text
                      Text(
                        _getLoadingText(_progressAnimation.value),
                        style: const TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Progress Percentage
                      Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
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
