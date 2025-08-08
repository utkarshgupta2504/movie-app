import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/movie_poster.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeViewModel>().refresh(),
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
                  'Movies',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppToast.error(context, viewModel.error);
                      context.read<HomeViewModel>().clearError();
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        context,
                        title: 'Trending Now',
                        movies: viewModel.trendingMovies,
                        isLoading: viewModel.isLoadingTrending,
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context,
                        title: 'Now Playing',
                        movies: viewModel.nowPlayingMovies,
                        isLoading: viewModel.isLoadingNowPlaying,
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List movies,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: isLoading
              ? const MovieGridShimmer()
              : movies.isEmpty
              ? const Center(
                  child: EmptyStateWidget(
                    icon: Icons.movie_outlined,
                    title: 'No Movies Available',
                    subtitle: 'Pull to refresh and try again',
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MoviePoster(
                      movie: movie,
                      onTap: () => context.push('/movie/${movie.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
