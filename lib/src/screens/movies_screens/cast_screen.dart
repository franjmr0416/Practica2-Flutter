import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:practica2/src/models/cast_movie_model.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/network/api_popular.dart';

class CastingScreen extends StatefulWidget {
  CastingScreen({Key? key}) : super(key: key);

  @override
  _CastingScreenState createState() => _CastingScreenState();
}

class _CastingScreenState extends State<CastingScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as PopularMoviesModel;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            movie.title!,
            style: TextStyle(color: Colors.amber[600]),
          ),
          backgroundColor: Colors.black87,
        ),
        body: _castList(movie.id, movie.posterPath));
  }

  Widget _castList(id, poster) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('https://image.tmdb.org/t/p/w500/$poster'),
              fit: BoxFit.fill)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: FutureBuilder(
          future: apiPopular!.getCastById(id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<CastMovieModel>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Hay un error en la peticion'),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _listCastImages(snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _listCastImages(List<CastMovieModel>? cast) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cast!.length,
      itemBuilder: (context, index) {
        CastMovieModel casting = cast[index];

        var imgActor = casting.profile_path;

        return Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                      child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: imgActor == null
                          ? 'https://img.icons8.com/ios-glyphs/300/ffffff/user--v1.png'
                          : 'https://image.tmdb.org/t/p/w300${casting.profile_path}',
                      imageBuilder: (context, imageProvider) => Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 5),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                        child: Icon(
                          Icons.error,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ))
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 300,
                      child: Center(
                        child: Text(
                          casting.name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              shadows: [
                                Shadow(
                                    color: Colors.black87,
                                    offset: Offset(0, 2),
                                    blurRadius: 25)
                              ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 300,
                      child: Center(
                        child: Text(
                          casting.character!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                    color: Colors.black87,
                                    offset: Offset(0, 2),
                                    blurRadius: 25)
                              ]),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        );
      },
    );
  }
}
