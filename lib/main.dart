import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/category_page.dart';
import 'pages/movie_detail_page.dart';

void main() {
  // Definisikan kunci API secara langsung
  const apiKey = 'a51df72605b576b9272682d74739ea89';

  runApp(MyApp(apiKey: apiKey));
}

class MyApp extends StatelessWidget {
  final String apiKey;

  MyApp({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF38102C),
      ),
      home: HomePage(apiKey: apiKey),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/category':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CategoryPage(
                genreId: args['id'],
                genreName: args['name'],
                apiKey: apiKey,
              ),
            );
          case '/movieDetail':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MovieDetailPage(
                movieId: args['id'],
                apiKey: apiKey,
              ),
            );
          default:
            return MaterialPageRoute(
                builder: (context) => HomePage(apiKey: apiKey));
        }
      },
    );
  }
}
