import 'package:flutter/material.dart';
import '../models/video_item.dart';

class HorizontalCarousel extends StatelessWidget {
  final String title;
  final List<VideoItem> videos;
  final void Function(int index) onTap;

  const HorizontalCarousel({
    Key? key,
    required this.title,
    required this.videos,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // Horizontal Carousel
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color(0xFF1A1A1C),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              video.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                    'Image failed to load: ${video.thumbnail}');
                                return Container(
                                  color: const Color(0xFF1A1A1C),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.movie,
                                          color: Color(0xFFB3B3B3),
                                          size: 32,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          video.title,
                                          style: const TextStyle(
                                            color: Color(0xFFB3B3B3),
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: const Color(0xFF1A1A1C),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFE50914),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Optional: Video title (uncomment if needed)
                      // const SizedBox(height: 4),
                      // Text(
                      //   video.title,
                      //   style: const TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
