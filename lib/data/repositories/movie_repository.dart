import 'package:connectivity_plus/connectivity_plus.dart';
import '../api/tmdb_api_service.dart';
import '../database/database_helper.dart';
import '../models/movie.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';

class MovieRepository {
  final TmdbApiService _apiService;
  final DatabaseHelper _databaseHelper;
  final Connectivity _connectivity;

  MovieRepository({
    required TmdbApiService apiService,
    required DatabaseHelper databaseHelper,
    required Connectivity connectivity,
  }) : _apiService = apiService,
       _databaseHelper = databaseHelper,
       _connectivity = connectivity;

  Future<List<Movie>> getTrendingMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected && (forceRefresh || page == 1)) {
        final response = await _apiService.getTrendingMovies(
          AppConstants.tmdbApiKey,
          page,
        );

        if (page == 1) {
          await _databaseHelper.clearMoviesByCategory('trending');
        }
        await _databaseHelper.insertMovies(response.results, 'trending');

        return response.results;
      }
    } catch (e, st) {
      AppLogger.e('getTrendingMovies failed', e, st);
      // Log error without print in production
      throw Exception('Failed to load trending movies: $e');
    }
    return await _databaseHelper.getMoviesByCategory('trending');
  }

  Future<List<Movie>> getNowPlayingMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected && (forceRefresh || page == 1)) {
        final response = await _apiService.getNowPlayingMovies(
          AppConstants.tmdbApiKey,
          page,
        );

        if (page == 1) {
          await _databaseHelper.clearMoviesByCategory('now_playing');
        }
        await _databaseHelper.insertMovies(response.results, 'now_playing');

        return response.results;
      }
    } catch (e, st) {
      AppLogger.e('getNowPlayingMovies failed', e, st);
      // Log error without print in production
      throw Exception('Failed to load now playing movies: $e');
    }

    return await _databaseHelper.getMoviesByCategory('now_playing');
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        final response = await _apiService.searchMovies(
          AppConstants.tmdbApiKey,
          query,
          page,
        );

        await _databaseHelper.insertMovies(response.results, 'search');
        return response.results;
      }
    } catch (e, st) {
      AppLogger.e('searchMovies failed', e, st);
      // Log error without print in production
      throw Exception('Failed to search movies: $e');
    }
    return await _databaseHelper.searchMoviesLocal(query);
  }

  Future<Movie?> getMovieDetails(int movieId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        final movie = await _apiService.getMovieDetails(
          movieId,
          AppConstants.tmdbApiKey,
        );
        await _databaseHelper.insertMovies([movie], 'details');
        return movie;
      }
    } catch (e, st) {
      AppLogger.e('getMovieDetails failed', e, st);
      // Log error without print in production
      throw Exception('Failed to get movie details: $e');
    }
    final localMovies = await _databaseHelper.getMoviesByCategory('details');
    return localMovies.firstWhere(
      (movie) => movie.id == movieId,
      orElse: () => throw Exception('Movie not found'),
    );
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    return await _databaseHelper.getBookmarkedMovies();
  }

  Future<void> toggleBookmark(int movieId) async {
    await _databaseHelper.toggleBookmark(movieId);
  }

  Future<bool> isMovieBookmarked(int movieId) async {
    return await _databaseHelper.isMovieBookmarked(movieId);
  }
}
