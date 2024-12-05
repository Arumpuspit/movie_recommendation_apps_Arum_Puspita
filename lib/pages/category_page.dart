import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CategoryPage extends StatelessWidget {
  final int genreId;
  final String genreName;
  final String apiKey;

  const CategoryPage({
    Key? key,
    required this.genreId,
    required this.genreName,
    required this.apiKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService(apiKey: apiKey);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('$genreName Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF38102C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchMoviesByGenre(genreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)),
            );
          } else {
            final movies = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth < 600 ? 2 : 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  color: Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/movieDetail',
                        arguments: {'id': movie['id']},
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Rating: ${movie['vote_average']}',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
