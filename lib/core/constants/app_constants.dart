import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String movieShareBaseUrl = 'https://utkarshg.is-a.dev/movie';

  static const int defaultPageSize = 20;
  static const int debounceDelayMs = 500;

  static const String fontFamily = 'Inter';
}
