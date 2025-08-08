import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieRepository _movieRepository;

  HomeViewModel({required MovieRepository movieRepository})
    : _movieRepository = movieRepository;

  List<Movie> _trendingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  bool _isLoadingTrending = false;
  bool _isLoadingNowPlaying = false;
  String _error = '';

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingNowPlaying => _isLoadingNowPlaying;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  Future<void> loadMovies({bool forceRefresh = false}) async {
    await Future.wait([
      loadTrendingMovies(forceRefresh: forceRefresh),
      loadNowPlayingMovies(forceRefresh: forceRefresh),
    ]);
  }

  Future<void> loadTrendingMovies({bool forceRefresh = false}) async {
    if (_isLoadingTrending) return;

    _isLoadingTrending = true;
    _error = '';
    notifyListeners();

    try {
      final movies = await _movieRepository.getTrendingMovies(
        forceRefresh: forceRefresh,
      );
      _trendingMovies = movies;
      _error = '';
    } catch (e, st) {
      _error = 'Failed to load trending movies';
      AppLogger.e('loadTrendingMovies failed', e, st);
    } finally {
      _isLoadingTrending = false;
      notifyListeners();
    }
  }

  Future<void> loadNowPlayingMovies({bool forceRefresh = false}) async {
    if (_isLoadingNowPlaying) return;

    _isLoadingNowPlaying = true;
    _error = '';
    notifyListeners();

    try {
      final movies = await _movieRepository.getNowPlayingMovies(
        forceRefresh: forceRefresh,
      );
      _nowPlayingMovies = movies;
      _error = '';
    } catch (e, st) {
      _error = 'Failed to load now playing movies';
      AppLogger.e('loadNowPlayingMovies failed', e, st);
    } finally {
      _isLoadingNowPlaying = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadMovies(forceRefresh: true);
  }

  void clearError() {
    if (_error.isNotEmpty) {
      _error = '';
      notifyListeners();
    }
  }
}
