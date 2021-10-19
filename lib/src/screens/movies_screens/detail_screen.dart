import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practica2/src/models/popular_movies_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool like = false;
  Icon btnLike = Icon(
    Icons.favorite_border,
    size: 50,
    color: Colors.white70,
  );

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 10),
                        child: Image(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
                          width: 200,
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
                        color: Colors.black54,
                        child: Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 0, top: 10),
                                child: Container(
                                  width: 300,
                                  child: Text(
                                    movie.title.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.none,
                                      color: Colors.amber[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 7),
                                child: GestureDetector(
                                  child: btnLike,
                                  onTap: () => _evalLike(),
                                ),
                              )
                            ]),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    print("ver trailer");
                                  },
                                  icon: Icon(Icons.play_circle_outline),
                                  label: Text('Ver Trailer'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black54),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Descripción:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
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
                                        movie.overview.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 7,
                                        style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.none,
                                            color: Colors.white70),
                                      ),
                                      width: 300,
                                    ),
                                  )
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Reparto:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            /*Row(
                              children: [
                                Container(
                                  child: ListView(
                                    //scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        width: 160.0,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width: 160.0,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )*/
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

  void _evalLike() {
    if (like) {
      like = false;
      btnLike = Icon(
        Icons.favorite,
        color: Colors.red,
        size: 50,
      );
    } else {
      like = true;
      btnLike = Icon(
        Icons.favorite_border_outlined,
        color: Colors.white70,
        size: 50,
      );
    }
    setState(() {});
  }
}
