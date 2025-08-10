import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/movie.dart';
import '../../core/theme/app_colors.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool showTitle;
  final bool showRating;

  const MoviePoster({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 140,
    this.height = 200,
    this.showTitle = true,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie_poster_${movie.id}',
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: movie.fullPosterUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: movie.fullPosterUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _buildShimmer(),
                          errorWidget: (context, url, error) =>
                              _buildErrorWidget(),
                        )
                      : _buildErrorWidget(),
                ),
              ),
            ),
            if (showTitle || showRating) ...[
              const SizedBox(height: 8),
              if (showTitle)
                Text(
                  movie.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (showRating) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      movie.ratingText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: AppColors.shimmerBase),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColors.shimmerBase,
      child: const Icon(Icons.movie, color: AppColors.textTertiary, size: 40),
    );
  }
}
