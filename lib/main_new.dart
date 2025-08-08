import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

// import 'presentation/viewmodels/home_viewmodel.dart';
// import 'presentation/viewmodels/search_viewmodel.dart';
// import 'presentation/viewmodels/bookmark_viewmodel.dart';
// import 'presentation/viewmodels/movie_detail_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DependencyInjection.createHomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DependencyInjection.createSearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DependencyInjection.createBookmarkViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DependencyInjection.createMovieDetailViewModel(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Movie Database',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
