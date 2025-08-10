import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final Set<int> _bookmarkedMovieIds = <int>{};

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
      await _loadBookmarkedMovies();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        poster_path TEXT,
        backdrop_path TEXT,
        release_date TEXT,
        vote_average REAL,
        vote_count INTEGER,
        adult INTEGER,
        original_language TEXT,
        original_title TEXT,
        popularity REAL,
        video INTEGER,
        is_bookmarked INTEGER DEFAULT 0,
        category TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_movies_category ON movies(category);
    ''');

    await db.execute('''
      CREATE INDEX idx_movies_bookmarked ON movies(is_bookmarked);
    ''');
  }

  Future<void> _loadBookmarkedMovies() async {
    final db = await _database!;
    final List<Map<String, dynamic>> bookmarkedMovies = await db.query(
      'movies',
      columns: ['id'],
      where: 'is_bookmarked = ?',
      whereArgs: [1],
    );

    _bookmarkedMovieIds.clear();
    for (final movie in bookmarkedMovies) {
      _bookmarkedMovieIds.add(movie['id'] as int);
    }
  }

  Future<void> insertMovies(List<Movie> movies, String category) async {
    final db = await database;
    final batch = db.batch();

    for (final movie in movies) {
      final isBookmarked = _bookmarkedMovieIds.contains(movie.id) ? 1 : 0;

      batch.insert('movies', {
        'id': movie.id,
        'title': movie.title,
        'description': movie.description,
        'poster_path': movie.posterPath,
        'backdrop_path': movie.backdropPath,
        'release_date': movie.releaseDate,
        'vote_average': movie.voteAverage,
        'vote_count': movie.voteCount,
        'adult': movie.adult ? 1 : 0,
        'original_language': movie.originalLanguage,
        'original_title': movie.originalTitle,
        'popularity': movie.popularity,
        'video': movie.video ? 1 : 0,
        'is_bookmarked': isBookmarked,
        'category': category,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  Future<List<Movie>> getMoviesByCategory(String category) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToMovie(map)).toList();
  }

  Future<Movie> getMovieById(int movieId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [movieId],
    );

    if (maps.isNotEmpty) {
      return _mapToMovie(maps.first);
    } else {
      throw Exception('Movie not found');
    }
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'is_bookmarked = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToMovie(map)).toList();
  }

  Future<void> toggleBookmark(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> existing = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [movieId],
    );

    if (existing.isNotEmpty) {
      final isCurrentlyBookmarked = _bookmarkedMovieIds.contains(movieId);
      final newBookmarkStatus = isCurrentlyBookmarked ? 0 : 1;

      await db.update(
        'movies',
        {'is_bookmarked': newBookmarkStatus},
        where: 'id = ?',
        whereArgs: [movieId],
      );

      // Update in-memory cache
      if (isCurrentlyBookmarked) {
        _bookmarkedMovieIds.remove(movieId);
      } else {
        _bookmarkedMovieIds.add(movieId);
      }
    }
  }

  Future<bool> isMovieBookmarked(int movieId) async {
    await database; // Ensure database is initialized
    return _bookmarkedMovieIds.contains(movieId);
  }

  Future<List<Movie>> searchMoviesLocal(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'popularity DESC',
    );

    return maps.map((map) => _mapToMovie(map)).toList();
  }

  Movie _mapToMovie(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      posterPath: map['poster_path'],
      backdropPath: map['backdrop_path'],
      releaseDate: map['release_date'],
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      voteCount: map['vote_count'] ?? 0,
      adult: map['adult'] == 1,
      originalLanguage: map['original_language'] ?? '',
      originalTitle: map['original_title'] ?? '',
      popularity: map['popularity']?.toDouble() ?? 0.0,
      video: map['video'] == 1,
    );
  }

  Future<void> clearMoviesByCategory(String category) async {
    final db = await database;
    await db.delete('movies', where: 'category = ?', whereArgs: [category]);
  }
}
