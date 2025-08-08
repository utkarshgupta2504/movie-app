import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        builder: (context, child) => ToastificationWrapper(child: child!),
      ),
    );
  }
}
