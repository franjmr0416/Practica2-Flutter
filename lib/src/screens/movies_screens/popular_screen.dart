import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:practica2/src/views/card_popular.dart';

class PopularScreen extends StatefulWidget {
  PopularScreen({Key? key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen>
    with TickerProviderStateMixin {
  late TabController _tabControlador;
  ApiPopular? apiPopular;
  late DatabaseHelper _databaseHelper;
  PopularMoviesModel? popularMoviesModel;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    _databaseHelper = DatabaseHelper();
    _tabControlador = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Movies',
            style: TextStyle(
              color: Colors.amber[600],
            ),
          ),
          backgroundColor: Colors.black87,
          bottom: TabBar(controller: _tabControlador, tabs: const <Widget>[
            Tab(
              text: 'Top Movies',
            ),
            Tab(
              text: 'Favs',
            )
          ]),
        ),
        body: TabBarView(
          controller: _tabControlador,
          children: <Widget>[_topMoviesTab(), _favsTab()],
        ));
  }

  Widget _topMoviesTab() {
    return Container(
      color: Colors.black87,
      child: FutureBuilder(
          future: apiPopular!.getAllPopular(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PopularMoviesModel>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Hay un error en la peticion'),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _listPopularMovies(snapshot.data);
                //return Center();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }

  Widget _listPopularMovies(List<PopularMoviesModel>? movies) {
    return ListView.separated(
        itemBuilder: (context, index) {
          PopularMoviesModel popular = movies![index];
          return CardPopularView(popular: popular);
        },
        separatorBuilder: (_, __) => Divider(
              height: 10,
            ),
        itemCount: movies!.length);
  }

  Widget _favsTab() {
    return Container(
      color: Colors.black87,
      child: FutureBuilder(
          future: _databaseHelper.getAllFavs(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PopularMoviesModel>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Hay un error en la peticion'),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isNotEmpty) {
                  return _listPopularMovies(snapshot.data);
                } else {
                  return Center(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.amber,
                          size: 50,
                        ),
                      ),
                      Text(
                        'Aún no tienes favoritos!',
                        style: TextStyle(color: Colors.amber, fontSize: 20),
                      )
                    ],
                  ));
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }
}
