import 'package:flutter/material.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/network/api_popular.dart';

class PopularScreen extends StatefulWidget {
  PopularScreen({Key? key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiPopular!.getAllPopular(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PopularMoviesModel>?> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Hay un error en la peticion'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              //return _listPopularMovies(snapshot.data);
              return Center();
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }
/*
  Widget _listPopularMovies(List<PopularMoviesModel>? movies) {
    ListView.separated(
        itemBuilder: (context, index) {
          PopularMoviesModel popular = movies![index];
          return CardPopularView(popular);
        },
        separatorBuilder: (_, __) => Divider(
              height: 10,
            ),
        itemCount: movies!.length);
  }
  */
}
