import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/search_screen.dart';
import '../../views/screens/bookmark_screen.dart';
import '../../views/screens/movie_detail_screen.dart';
import '../../views/screens/main_navigation_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;

          final location = state.uri.path;
          if (location.startsWith('/search')) {
            currentIndex = 1;
          } else if (location.startsWith('/bookmarks')) {
            currentIndex = 2;
          }

          return MainNavigationScreen(currentIndex: currentIndex, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/bookmarks',
            builder: (context, state) => const BookmarkScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailScreen(movieId: movieId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
