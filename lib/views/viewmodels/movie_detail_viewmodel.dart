import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final MovieRepository _movieRepository;

  MovieDetailViewModel({required MovieRepository movieRepository})
    : _movieRepository = movieRepository;

  Movie? _movieDetails;
  bool _isLoading = false;
  bool _isBookmarked = false;
  String _error = '';

  Movie? get movieDetails => _movieDetails;
  bool get isLoading => _isLoading;
  bool get isBookmarked => _isBookmarked;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  Future<void> loadMovieDetails(int movieId) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final movie = await _movieRepository.getMovieDetails(movieId);
      _movieDetails = movie;
      await _checkBookmarkStatus(movieId);
      _error = '';
    } catch (e, st) {
      _error = 'Failed to load movie details';
      AppLogger.e('loadMovieDetails failed', e, st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark() async {
    if (_movieDetails == null) return;

    try {
      await _movieRepository.toggleBookmark(_movieDetails!.id);
      _isBookmarked = !_isBookmarked;
      notifyListeners();
    } catch (e, st) {
      _error = 'Failed to update bookmark';
      AppLogger.e('toggleBookmark failed', e, st);
      notifyListeners();
    }
  }

  Future<void> _checkBookmarkStatus(int movieId) async {
    try {
      _isBookmarked = await _movieRepository.isMovieBookmarked(movieId);
    } catch (e, st) {
      AppLogger.e('checkBookmarkStatus failed', e, st);
    }
  }

  void shareMovie() {
    if (_movieDetails == null) return;

    final movie = _movieDetails!;
    final shareUrl = '${AppConstants.movieShareBaseUrl}/${movie.id}';
    final shareText =
        'Check out "${movie.title}" - ${movie.description?.substring(0, 100) ?? ''}... $shareUrl';

    Share.share(shareText, subject: movie.title);
  }

  Future<void> openTrailer() async {
    if (_movieDetails == null) return;

    final searchQuery = '${_movieDetails!.title} trailer';
    final youtubeUrl =
        'https://www.youtube.com/results?search_query=${Uri.encodeComponent(searchQuery)}';

    try {
      final uri = Uri.parse(youtubeUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, st) {
      _error = 'Failed to open trailer';
      AppLogger.e('openTrailer failed', e, st);
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
