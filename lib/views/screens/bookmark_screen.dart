import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/bookmark_viewmodel.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/toast.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkViewModel>().loadBookmarkedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<BookmarkViewModel>().refresh(),
        color: AppColors.accent,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Bookmarks',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<BookmarkViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppToast.error(context, viewModel.error);
                      context.read<BookmarkViewModel>().clearError();
                    });
                  }

                  if (viewModel.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MovieListShimmer(),
                    );
                  }

                  if (!viewModel.hasBookmarks) {
                    return const EmptyStateWidget(
                      icon: Icons.bookmark_border,
                      title: 'No Bookmarks Yet',
                      subtitle: 'Save your favorite movies to see them here',
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${viewModel.bookmarkedMovies.length} saved movies',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.bookmarkedMovies.length,
                        itemBuilder: (context, index) {
                          final movie = viewModel.bookmarkedMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () => context.push('/movie/${movie.id}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                color: AppColors.accent,
                              ),
                              onPressed: () {
                                viewModel.toggleBookmark(movie);
                                AppToast.info(
                                  context,
                                  '${movie.title} removed from bookmarks',
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
