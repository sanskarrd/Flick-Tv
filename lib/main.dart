import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/video_bloc.dart';
import 'repository/local_repository.dart';
import 'pages/splash_page.dart';
import 'util/strings.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = LocalRepository();

    return BlocProvider(
      create: (_) => VideoBloc(repository: repo),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appTitle,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor:
              const Color(0xFF141414), // Netflix dark background
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          cardColor: const Color(0xFF2F2F2F),
          primaryColor: const Color(0xFFE50914), // Netflix red
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE50914),
            secondary: Color(0xFFE50914),
            surface: Color(0xFF141414),
            background: Color(0xFF141414),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onBackground: Colors.white,
          ),
          textTheme: const TextTheme(
            // Netflix-style typography
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.25,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.25,
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.15,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFFE5E5E5),
              letterSpacing: 0.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFFB3B3B3),
              letterSpacing: 0.25,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0xFF8C8C8C),
              letterSpacing: 0.4,
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
