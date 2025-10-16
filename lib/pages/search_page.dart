import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_bloc.dart';
import '../bloc/video_state.dart';
import '../models/video_item.dart';
import '../util/strings.dart';
import 'player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoItem> _searchResults = [];
  List<VideoItem> _allVideos = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
    });
    _performSearch(_searchQuery);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = _allVideos.where((video) {
      return video.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  void _navigateToPlayer(VideoItem video) {
    final videoIndex = _allVideos.indexOf(video);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          videos: _allVideos,
          initialIndex: videoIndex >= 0 ? videoIndex : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoaded) {
            // Flatten all videos from categories
            _allVideos =
                state.categories.expand((category) => category).toList();
          }

          return SafeArea(
            child: Column(
              children: [
                // Search Header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Search bar
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F2F2F),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isSearching
                                  ? const Color(0xFFE50914)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: Strings.searchHint,
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Results
                Expanded(
                  child: _buildSearchContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchContent() {
    if (!_isSearching) {
      return _buildPopularSearches();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      Strings.actionMovies,
      Strings.comedyShows,
      Strings.documentaries,
      Strings.thriller,
      Strings.romance,
      Strings.sciFi,
      Strings.horror,
      Strings.drama,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Strings.popularSearches,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F2F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          if (_allVideos.isNotEmpty) ...[
            const Text(
              Strings.browseAll,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildVideoGrid(_allVideos.take(20).toList()),
          ],
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '${Strings.noResultsTitle} "$_searchQuery"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            Strings.noResultsSubtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_searchResults.length} ${Strings.resultsFor} "$_searchQuery"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildVideoGrid(_searchResults),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(List<VideoItem> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () => _navigateToPlayer(video),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2F2F2F),
                        child: const Icon(
                          Icons.movie,
                          color: Color(0xFF8C8C8C),
                          size: 40,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  // Title overlay
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Text(
                      video.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
