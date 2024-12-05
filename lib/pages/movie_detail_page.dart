import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;
  final String apiKey;

  const MovieDetailPage({Key? key, required this.movieId, required this.apiKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService(apiKey: apiKey);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF38102C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFF38102C),
        child: FutureBuilder<Map<String, dynamic>>(
          future: apiService.fetchMovieDetails(movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)),
              );
            } else {
              final movieDetails = snapshot.data!;
              return _buildMovieDetail(context, movieDetails, screenWidth);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(
      BuildContext context, Map<String, dynamic> movie, double screenWidth) {
    String imageUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              movie['title'],
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            Card(
              color: Color(0xFF4A235A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Genres:', _getGenres(movie['genres'])),
                    SizedBox(height: 8),
                    _buildDetailRow('Release Date:', movie['release_date']),
                    SizedBox(height: 8),
                    _buildRatingRow(
                        'Rating:', movie['vote_average'].toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Color(0xFF4A235A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie['overview'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 24),
              SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getGenres(List<dynamic> genres) {
    return genres.map((genre) => genre['name']).join(', ');
  }
}
