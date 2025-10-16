import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_bloc.dart';
import '../bloc/video_state.dart';
import '../widgets/horizontal_carousel.dart';
import 'player_page.dart';

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
                // Netflix-style App Bar with Logo
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  pinned: true,
                  snap: true,
                  backgroundColor: const Color(0xFF141414),
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF141414),
                          const Color(0xFF141414).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'FLICKTV',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE50914),
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement search
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle,
                            color: Colors.white),
                        onPressed: () {
                          // TODO: Implement profile
                        },
                      ),
                    ],
                  ),
                ),
                // Hero Banner Section
                SliverToBoxAdapter(
                  child: _buildHeroBanner(
                      categories.isNotEmpty ? categories[0][0] : null),
                ),
                // Category Sections
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final categoryTitles = [
                        'Trending Now',
                        'Popular on FlickTV',
                        'Watch It Again',
                        'New Releases',
                        'My List',
                        'Action & Adventure',
                        'Comedies',
                        'Documentaries',
                      ];
                      final catIndex = index % categories.length;
                      final cat = categories[catIndex];
                      final title = index < categoryTitles.length
                          ? categoryTitles[index]
                          : categoryTitles[index % categoryTitles.length];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
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
                    childCount: 6, // Show more categories like Netflix
                  ),
                ),
                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
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
    return Container(
      height: 500,
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2F2F2F),
                        Color(0xFF141414),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      size: 80,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                );
              },
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2F2F2F),
                    Color(0xFF141414),
                  ],
                ),
              ),
            ),

          // Netflix-style gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x66000000),
                  Color(0xFF141414),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Content Overlay
          Positioned(
            left: 20,
            right: 20,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Netflix-style "N" series badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SERIES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Featured Content Title
                Text(
                  featuredVideo?.title ?? 'Featured Content',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  _getVideoDescription(featuredVideo?.title),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                // Netflix-style action buttons
                Row(
                  children: [
                    // Play button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (featuredVideo != null) {
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
                        icon: const Icon(Icons.play_arrow, color: Colors.black),
                        label: const Text(
                          'Play',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // My List button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add to my list functionality
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'My List',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F2F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getVideoDescription(String? title) {
    if (title == null) return 'Discover amazing content on FlickTV';

    // Generate Netflix-style descriptions based on title
    switch (title.toLowerCase()) {
      case 'big buck bunny':
        return 'Follow the adventures of Big Buck Bunny in this heartwarming animated short film.';
      case 'elephant dream':
        return 'A surreal journey through a dreamlike world filled with mystery and wonder.';
      case 'for bigger blazes':
        return 'An action-packed adventure that will keep you on the edge of your seat.';
      case 'for bigger escape':
        return 'A thrilling escape story with unexpected twists and turns.';
      default:
        return 'Experience premium entertainment with stunning visuals and captivating storytelling.';
    }
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
