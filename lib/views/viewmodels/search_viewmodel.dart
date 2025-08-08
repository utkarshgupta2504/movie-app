import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';

class SearchViewModel extends ChangeNotifier {
  final MovieRepository _movieRepository;

  SearchViewModel({required MovieRepository movieRepository})
    : _movieRepository = movieRepository;

  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  String _currentQuery = '';
  Timer? _debounceTimer;

  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  String get currentQuery => _currentQuery;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get showEmptyState =>
      !_isLoading && _searchResults.isEmpty && _currentQuery.isNotEmpty;

  void searchMovies(String query) {
    _currentQuery = query.trim();

    _debounceTimer?.cancel();

    if (_currentQuery.isEmpty) {
      _clearResults();
      return;
    }

    _debounceTimer = Timer(
      Duration(milliseconds: AppConstants.debounceDelayMs),
      () => _performSearch(_currentQuery),
    );
  }

  Future<void> _performSearch(String query) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final movies = await _movieRepository.searchMovies(query);
      _searchResults = movies;
      _error = '';
    } catch (e, st) {
      _error = 'Failed to search movies';
      _searchResults = [];
      AppLogger.e('searchMovies failed', e, st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearResults() {
    _searchResults = [];
    _error = '';
    _currentQuery = '';
    notifyListeners();
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _clearResults();
  }

  void clearError() {
    if (_error.isNotEmpty) {
      _error = '';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
