import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class MovieListShimmer extends StatelessWidget {
  final int itemCount;

  const MovieListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoadingShimmer(width: 120, height: 160),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingShimmer(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    LoadingShimmer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 16,
                    ),
                    const SizedBox(height: 8),
                    LoadingShimmer(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MovieGridShimmer extends StatelessWidget {
  final int itemCount;

  const MovieGridShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(width: 140, height: 200),
                SizedBox(height: 8),
                LoadingShimmer(width: 100, height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailShimmer extends StatelessWidget {
  const MovieDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
                const LoadingShimmer(
                  width: double.infinity,
                  height: 400,
                  borderRadius: BorderRadius.zero,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.8),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                LoadingShimmer(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 32,
                ),
                const SizedBox(height: 16),

                // Rating and year shimmer
                Row(
                  children: [
                    const LoadingShimmer(width: 80, height: 20),
                    const SizedBox(width: 16),
                    const LoadingShimmer(width: 60, height: 20),
                    const SizedBox(width: 16),
                    const LoadingShimmer(width: 100, height: 20),
                  ],
                ),
                const SizedBox(height: 24),

                // Overview title shimmer
                const LoadingShimmer(width: 100, height: 24),
                const SizedBox(height: 12),

                // Overview text shimmer
                const LoadingShimmer(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                const LoadingShimmer(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                LoadingShimmer(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16,
                ),
                const SizedBox(height: 24),

                // Movie details shimmer
                const LoadingShimmer(width: 120, height: 24),
                const SizedBox(height: 16),

                Column(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LoadingShimmer(width: 100, height: 16),
                          const SizedBox(width: 16),
                          Expanded(
                            child: LoadingShimmer(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
