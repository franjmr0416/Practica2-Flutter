import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/cast_movie_model.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/models/video_movie_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:practica2/src/screens/movies_screens/cast_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool like = false;

  ApiPopular? apiPopular;
  late DatabaseHelper _databaseHelper;
  PopularMoviesModel? popularMoviesModel;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as PopularMoviesModel;

    return Hero(
      tag: movie.id.toString(),
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
                  fit: BoxFit.fill)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.chevron_left_sharp,
                                color: Colors.amber[600],
                                size: 50,
                              ),
                              Text(
                                'Pel??culas',
                                style: TextStyle(
                                    color: Colors.amber[600],
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black54,
                                          offset: Offset(1, 1),
                                          blurRadius: 7.0)
                                    ]),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}')),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black87,
                                    offset: Offset(3, 3),
                                    blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    //INFORMACION PELICULA
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //Fondo informacion

                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20, left: 10, right: 0, top: 20),
                                child: Container(
                                  width: 300,
                                  child: Text(
                                    movie.title.toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        decoration: TextDecoration.none,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              color: Colors.amber,
                                              offset: Offset(2, 3),
                                              blurRadius: 10),
                                          Shadow(
                                              color: Colors.black87,
                                              offset: Offset(3, 4),
                                              blurRadius: 10)
                                        ]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 7),
                                child: GestureDetector(
                                  child: FutureBuilder(
                                      future: _databaseHelper
                                          .checkFavsById(movie.id!)
                                          .then((value) => like = value),
                                      builder: (BuildContext context, bool) {
                                        return _likeBtn();
                                      }),
                                  onTap: () => _evalLike(movie),
                                ),
                              )
                            ]),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    print("ver trailer");
                                    Navigator.pushNamed(context, '/trailer',
                                        arguments: movie);
                                  },
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    'Ver Trailer',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.amber[600]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/casting',
                                          arguments: movie);
                                    },
                                    icon: Icon(
                                      Icons.people,
                                      color: Colors.black,
                                    ),
                                    label: Text('Ver Reparto',
                                        style: TextStyle(color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber[600],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Descripci??n:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: SizedBox(
                                      child: Text(
                                        (movie.overview!.length != 0)
                                            ? movie.overview.toString()
                                            : 'Sin descripci??n',
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 15,
                                        style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.none,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      width: 300,
                                    ),
                                  )
                                ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _evalLike(PopularMoviesModel movie) {
    if (like) {
      _databaseHelper
          .delete(movie.id!, 'favoritas')
          .then((value) => like = false);
    } else {
      _databaseHelper
          .insert(movie.toMap(), 'favoritas')
          .then((value) => like = true);
    }

    setState(() {});
  }

  Widget _likeBtn() {
    if (!like) {
      return Icon(
        Icons.favorite_border_outlined,
        color: Colors.white70,
        size: 50,
      );
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.red,
        size: 50,
      );
    }
  }
}
