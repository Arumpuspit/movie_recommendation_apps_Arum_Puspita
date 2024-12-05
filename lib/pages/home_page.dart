import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'movie_detail_page.dart';

class HomePage extends StatelessWidget {
  final String apiKey;

  HomePage({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService =
        ApiService(apiKey: apiKey); // Inisialisasi ApiService

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF38102C),
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WELCOME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'What kind of movie do you want to watch?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF38102C),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (query) {
                  // Tambahkan fungsi pencarian jika diperlukan
                },
              ),
              SizedBox(height: 24.0),
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.0),
              _buildGenresSection(apiService),
              SizedBox(height: 24.0),
              _buildPopularMoviesSection(apiService),
              SizedBox(height: 24.0),
              _buildLatestMoviesSection(apiService),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF38102C),
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildGenresSection(ApiService apiService) {
    return FutureBuilder<List<dynamic>>(
      future: apiService.fetchGenres(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: Colors.white),
          );
        } else {
          final genres = snapshot.data!;
          return Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return _buildGenreItem(context, genre);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildGenreItem(BuildContext context, dynamic genre) {
    IconData getGenreIcon(String genreName) {
      switch (genreName.toLowerCase()) {
        case 'action':
          return Icons.local_fire_department;
        case 'adventure':
          return Icons.explore;
        case 'animation':
          return Icons.animation;
        case 'comedy':
          return Icons.sentiment_very_satisfied;
        case 'crime':
          return Icons.local_police;
        case 'drama':
          return Icons.theater_comedy;
        case 'fantasy':
          return Icons.auto_awesome;
        case 'romance':
          return Icons.favorite;
        case 'sci-fi':
          return Icons.science;
        case 'thriller':
          return Icons.local_movies;
        default:
          return Icons.movie;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/category',
          arguments: {'id': genre['id'], 'name': genre['name']},
        );
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                getGenreIcon(genre['name']),
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              genre['name'],
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularMoviesSection(ApiService apiService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Movies',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.0),
        Container(
          height: 250,
          child: FutureBuilder<List<dynamic>>(
            future: apiService.fetchPopularMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                final movies = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildMovieItem(context, movie);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieItem(BuildContext context, dynamic movie) {
    String imageUrl = movie['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w200${movie['poster_path']}'
        : 'https://via.placeholder.com/100x150.png?text=No+Image';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/movieDetail',
                arguments: {'id': movie['id']},
              );
            },
            child: Image.network(
              imageUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey,
                  child: Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 100,
            child: Text(
              movie['title'],
              style: TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestMoviesSection(ApiService apiService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Movies',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 12.0),
        FutureBuilder<List<dynamic>>(
          future: apiService.fetchLatestMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              );
            } else {
              final movies = snapshot.data!;
              if (movies.isNotEmpty) {
                final movie = movies[0];
                return _buildLatestMovieItem(context, movie);
              } else {
                return Text(
                  'No latest movies available.',
                  style: TextStyle(color: Colors.white),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildLatestMovieItem(BuildContext context, dynamic movie) {
    String imageUrl = movie['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w200${movie['poster_path']}'
        : 'https://via.placeholder.com/100x150.png?text=No+Image';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 150,
                color: Colors.grey,
                child: Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Genre: ${_getGenres(movie['genre_ids'])}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Release Date: ${movie['release_date'] ?? 'Unknown'}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/movieDetail',
                      arguments: {'id': movie['id']},
                    );
                  },
                  child: Text('Details', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGenres(List<dynamic> genreIds) {
    return genreIds.join(', ');
  }
}
