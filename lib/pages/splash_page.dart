import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_bloc.dart';
import '../bloc/video_event.dart';
import '../bloc/video_state.dart';
import '../widgets/loading_screen.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Start loading data
    context.read<VideoBloc>().add(LoadVideos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoBloc, VideoState>(
      listener: (context, state) {
        print('Splash page state: $state');

        if (state is VideoLoaded && !_hasNavigated) {
          print('Data loaded successfully, navigating to home...');
          _hasNavigated = true;

          // Add a small delay to ensure loading animation completes
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
          });
        } else if (state is VideoError) {
          print('Error loading data: ${state.message}');
          // Still navigate to home with fallback data
          if (!_hasNavigated) {
            _hasNavigated = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }
            });
          }
        }
      },
      child: const LoadingScreen(),
    );
  }
}
