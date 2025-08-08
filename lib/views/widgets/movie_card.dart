import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/movie.dart';
import '../../core/theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showRating;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.trailing,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'movie_poster_${movie.id}',
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (trailing != null) trailing!,
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (showRating) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.ratingText,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              movie.formattedReleaseDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (movie.description != null &&
                          movie.description!.isNotEmpty)
                        Text(
                          movie.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
