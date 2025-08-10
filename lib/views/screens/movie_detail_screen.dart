import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/movie_detail_viewmodel.dart';
import '../viewmodels/bookmark_viewmodel.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/toast.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailViewModel>().loadMovieDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const MovieDetailShimmer();
          }

          if (viewModel.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppToast.error(
                context,
                viewModel.error,
                title: 'Error Loading Movie',
              );
            });
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Unable to load movie',
                  subtitle: 'Please check your connection and try again',
                ),
              ),
            );
          }

          final movie = viewModel.movieDetails;
          if (movie == null) {
            return const SizedBox.shrink();
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.background,
                iconTheme: const IconThemeData(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'movie_poster_${movie.id}',
                        child: movie.fullBackdropUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: movie.fullBackdropUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const LoadingShimmer(),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.surface,
                                  child: const Icon(
                                    Icons.movie,
                                    size: 80,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.surface,
                                child: const Icon(
                                  Icons.movie,
                                  size: 80,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withValues(alpha: 0.7),
                              AppColors.background,
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Consumer<BookmarkViewModel>(
                    builder: (context, bookmarkViewModel, child) {
                      final isBookmarked = viewModel.isBookmarked;
                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? AppColors.accent
                              : AppColors.textPrimary,
                        ),
                        onPressed: () {
                          viewModel.toggleBookmark();
                          bookmarkViewModel.toggleBookmark(movie);
                          // Show toast notification
                          // Opposite because we are toggling
                          AppToast.info(
                            context,
                            !viewModel.isBookmarked
                                ? '${movie.title} added to bookmarks'
                                : '${movie.title} removed from bookmarks',
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: AppColors.textPrimary),
                    onPressed: viewModel.shareMovie,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  movie.ratingText,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            movie.formattedReleaseDate,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: viewModel.openTrailer,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Watch Trailer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.description ?? 'No description available.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildInfoSection(context, movie),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movie Info',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(context, 'Original Title', movie.originalTitle),
        _buildInfoRow(
          context,
          'Language',
          movie.originalLanguage.toUpperCase(),
        ),
        _buildInfoRow(
          context,
          'Popularity',
          movie.popularity.toStringAsFixed(1),
        ),
        _buildInfoRow(context, 'Vote Count', movie.voteCount.toString()),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
