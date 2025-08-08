import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/utils/app_logger.dart';

class BookmarkViewModel extends ChangeNotifier {
  final MovieRepository _movieRepository;

  BookmarkViewModel({required MovieRepository movieRepository})
    : _movieRepository = movieRepository;

  List<Movie> _bookmarkedMovies = [];
  bool _isLoading = false;
  String _error = '';
  final Map<int, bool> _bookmarkStatus = {};

  List<Movie> get bookmarkedMovies => _bookmarkedMovies;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get hasBookmarks => _bookmarkedMovies.isNotEmpty;

  bool isBookmarked(int movieId) => _bookmarkStatus[movieId] ?? false;

  Future<void> loadBookmarkedMovies() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final movies = await _movieRepository.getBookmarkedMovies();
      _bookmarkedMovies = movies;

      _bookmarkStatus.clear();
      for (final movie in movies) {
        _bookmarkStatus[movie.id] = true;
      }

      _error = '';
    } catch (e, st) {
      _error = 'Failed to load bookmarked movies';
      AppLogger.e('loadBookmarkedMovies failed', e, st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(Movie movie) async {
    try {
      await _movieRepository.toggleBookmark(movie.id);

      final isCurrentlyBookmarked = _bookmarkStatus[movie.id] ?? false;
      _bookmarkStatus[movie.id] = !isCurrentlyBookmarked;

      if (!isCurrentlyBookmarked) {
        if (!_bookmarkedMovies.any((m) => m.id == movie.id)) {
          _bookmarkedMovies.insert(0, movie);
        }
      } else {
        _bookmarkedMovies.removeWhere((m) => m.id == movie.id);
      }

      notifyListeners();
    } catch (e, st) {
      _error = 'Failed to update bookmark';
      // Error logging removed for production
      AppLogger.e('toggleBookmark failed', e, st);
      notifyListeners();
    }
  }

  Future<void> checkBookmarkStatus(int movieId) async {
    try {
      final isBookmarked = await _movieRepository.isMovieBookmarked(movieId);
      _bookmarkStatus[movieId] = isBookmarked;
      notifyListeners();
    } catch (e, st) {
      AppLogger.e('checkBookmarkStatus failed', e, st);
    }
  }

  Future<void> refresh() async {
    await loadBookmarkedMovies();
  }

  void clearError() {
    if (_error.isNotEmpty) {
      _error = '';
      notifyListeners();
    }
  }
}
