import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/api/tmdb_api_service.dart';
import '../../data/database/database_helper.dart';
import '../../data/repositories/movie_repository.dart';
import '../../views/viewmodels/home_viewmodel.dart';
import '../../views/viewmodels/search_viewmodel.dart';
import '../../views/viewmodels/bookmark_viewmodel.dart';
import '../../views/viewmodels/movie_detail_viewmodel.dart';
import '../utils/app_logger.dart';

class DependencyInjection {
  static late Dio _dio;
  static late TmdbApiService _apiService;
  static late DatabaseHelper _databaseHelper;
  static late Connectivity _connectivity;
  static late MovieRepository _movieRepository;

  static Future<void> init() async {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.d('[HTTP] -> ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.d(
            '[HTTP] <- ${response.statusCode} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (e, handler) {
          AppLogger.e(
            '[HTTP] !! ${e.response?.statusCode} ${e.requestOptions.uri}',
            e,
            e.stackTrace,
          );
          return handler.next(e);
        },
      ),
    );

    _apiService = TmdbApiService(_dio);
    _databaseHelper = DatabaseHelper();
    _connectivity = Connectivity();

    _movieRepository = MovieRepository(
      apiService: _apiService,
      databaseHelper: _databaseHelper,
      connectivity: _connectivity,
    );

    await _databaseHelper.database;
  }

  static HomeViewModel createHomeViewModel() {
    return HomeViewModel(movieRepository: _movieRepository);
  }

  static SearchViewModel createSearchViewModel() {
    return SearchViewModel(movieRepository: _movieRepository);
  }

  static BookmarkViewModel createBookmarkViewModel() {
    return BookmarkViewModel(movieRepository: _movieRepository);
  }

  static MovieDetailViewModel createMovieDetailViewModel() {
    return MovieDetailViewModel(movieRepository: _movieRepository);
  }

  static MovieRepository get movieRepository => _movieRepository;
  static DatabaseHelper get databaseHelper => _databaseHelper;
  static TmdbApiService get apiService => _apiService;
}
