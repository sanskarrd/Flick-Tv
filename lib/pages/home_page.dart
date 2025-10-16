import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_bloc.dart';
import '../bloc/video_event.dart';
import '../bloc/video_state.dart';
import '../widgets/horizontal_carousel.dart';
import 'player_page.dart';
import '../util/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE50914),
              ),
            );
          }
          if (state is VideoError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state is VideoLoaded) {
            final categories = state.categories;
            return CustomScrollView(
              slivers: [
                // Hero Banner Section
                SliverAppBar(
                  expandedHeight: 250,
                  floating: false,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeroBanner(
                        categories.isNotEmpty ? categories[0][0] : null),
                  ),
                ),
                // Category Sections
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final categoryTitles = [
                        'Trending Now',
                        'Top Picks for You',
                        'Watch It Again'
                      ];
                      final catIndex = index % categories.length;
                      final cat = categories[catIndex];
                      final title = index < categoryTitles.length
                          ? categoryTitles[index]
                          : categoryTitles[index % categoryTitles.length];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: HorizontalCarousel(
                          title: title,
                          videos: cat,
                          onTap: (indexInCategory) {
                            _navigateToPlayer(
                                context, categories, catIndex, indexInCategory);
                          },
                        ),
                      );
                    },
                    childCount: 3, // Show 3 categories
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeroBanner(dynamic featuredVideo) {
    return GestureDetector(
      onTap: () {
        if (featuredVideo != null) {
          // Navigate to player with just the featured video
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlayerPage(
                videos: [featuredVideo],
                initialIndex: 0,
              ),
            ),
          );
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (featuredVideo != null)
            Image.network(
              featuredVideo.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF1A1A1C),
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      size: 64,
                      color: Color(0xFFB3B3B3),
                    ),
                  ),
                );
              },
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A1C),
                    Color(0xFF0E0E10),
                  ],
                ),
              ),
            ),

          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x80000000),
                  Color(0xFF0E0E10),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Content Overlay
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo
                Text(
                  Strings.appOnly,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                // Featured Content Title
                Text(
                  'Sci-Fi Thriller',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPlayer(BuildContext context, List<List> categories,
      int catIndex, int indexInCategory) {
    // Flatten all videos
    final flattened = <dynamic>[];
    for (var c in categories) {
      flattened.addAll(c);
    }

    // Compute global index
    int globalIndex = 0;
    for (int i = 0; i < catIndex; i++) {
      globalIndex += categories[i].length;
    }
    globalIndex += indexInCategory;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          videos: List.from(flattened),
          initialIndex: globalIndex,
        ),
      ),
    );
  }
}
