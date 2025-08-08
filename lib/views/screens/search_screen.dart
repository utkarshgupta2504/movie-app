import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/toast.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Movies',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (query) {
                    context.read<SearchViewModel>().searchMovies(query);
                  },
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search for movies...',
                    hintStyle: const TextStyle(color: AppColors.textTertiary),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textTertiary,
                    ),
                    suffixIcon: Consumer<SearchViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.currentQuery.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textTertiary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              context.read<SearchViewModel>().clearSearch();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const MovieListShimmer();
                }

                if (viewModel.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppToast.error(
                      context,
                      viewModel.error,
                      title: 'Search Failed',
                    );
                    context.read<SearchViewModel>().clearError();
                  });
                  // Fall through to show empty state instead of blank/error card
                }

                if (viewModel.showEmptyState) {
                  return const EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No Results Found',
                    subtitle: 'Try searching for a different movie title',
                  );
                }

                if (viewModel.currentQuery.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.movie_filter_outlined,
                    title: 'Discover Movies',
                    subtitle:
                        'Search for your favorite movies and discover new ones',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: viewModel.searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = viewModel.searchResults[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => context.push('/movie/${movie.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
