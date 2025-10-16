import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/video_bloc.dart';
import 'repository/local_repository.dart';
import 'pages/splash_page.dart';

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
        title: 'Flutter OTT Prototype',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0E0E10),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          cardColor: const Color(0xFF1A1A1C),
          primaryColor: const Color(0xFFE50914),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE50914),
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Color(0xFFB3B3B3),
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
