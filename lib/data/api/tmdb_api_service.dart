import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/movie_response.dart';
import '../models/movie.dart';

part 'tmdb_api_service.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3')
abstract class TmdbApiService {
  factory TmdbApiService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _TmdbApiService;

  @GET('/trending/movie/day')
  Future<MovieResponse> getTrendingMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/movie/now_playing')
  Future<MovieResponse> getNowPlayingMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/search/movie')
  Future<MovieResponse> searchMovies(
    @Query('api_key') String apiKey,
    @Query('query') String query,
    @Query('page') int page,
  );

  @GET('/movie/{movie_id}')
  Future<Movie> getMovieDetails(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );
}
