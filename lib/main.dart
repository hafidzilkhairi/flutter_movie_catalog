import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_movie_catalog/data/api_provider.dart';
import 'package:flutter_movie_catalog/model/popular_movies.dart';

void main() => runApp(MoviewApp());

class MoviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiProvider provider = ApiProvider();
  Future<PopularMovies> popularMovies;

  @override
  void initState() {
    popularMovies = provider.getPopularMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies App'),
      ),
      body: FutureBuilder(
        future: popularMovies,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print('Has data: ${snapshot.hasData}');
            return ListView.builder(
              itemCount: snapshot.data.results.length,
              itemBuilder: (BuildContext context, int index) {
                return moviesItem(
                    poster: '${snapshot.data.results[index].posterPath}',
                    title: '${snapshot.data.results[index].title}',
                    date: '${snapshot.data.results[index].releaseDate}',
                    voteAverage: '${snapshot.data.results[index].voteAverage}',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MovieDetail(
                          movie: snapshot.data.results[index],
                        ),
                      ));
                    });
              },
            );
          } else if (snapshot.hasError) {
            print('Has data: ${snapshot.hasError}');
            return Text('Error!!!');
          } else {
            print('Lagi loading....');
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  InkWell moviesItem(
      {String poster,
      String title,
      String date,
      String voteAverage,
      Function onTap}) {
    String baseUrlImage = 'https://image.tmdb.org/t/p/w500';
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  color: Colors.indigo,
                  child: CachedNetworkImage(
                    imageUrl: '$baseUrlImage$poster',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('$date'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 12,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('$voteAverage'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieDetail extends StatelessWidget {

  final Results movie;

  const MovieDetail({Key key, this.movie}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          movie.overview,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
