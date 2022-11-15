import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/model/popular_movie.dart';
import 'data/api_provider.dart';

void main() => runApp(movieApp());

class movieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie DB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiProvide apiProvider = ApiProvide();
  late Future <PopularMovies> popularMovies;

  String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

@override
void initState() {
  popularMovies = apiProvider.getPopularMovie();
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Movie DB'),
    ),
    body: FutureBuilder<PopularMovies>(
      future: popularMovies,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.results.length,
            itemBuilder: (BuildContext context, int index) {
              return movieItem(
                poster:
                '$imageBaseUrl${snapshot.data.results[index].posterPath}',
                title: '${snapshot.data.results[index].title}',
                date: '${snapshot.data.results[index].releaseDate}',
                vote: '${snapshot.data.results[index].voteAverage}',
                onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MovieDetail(
                    movie: snapshot.data.results[index],
                  )));
            },
          );
          });
          } else if (snapshot.hasError) {
          print("Has Error: ${snapshot.error}");
          return Text('Error!!!');
        } else {
          print("Loading...");
          return CircularProgressIndicator();
        }
        },
    ),
  );
}

Widget movieItem(
    {required String poster,
    required String title,
    required String date,
    required String vote,
    required Function()? onTap}) {
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
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: poster,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                          ),),
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
                            Text(date),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                            Text(vote),
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
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Container(
        child: Column(
        ),
      ),
    );
  }
}