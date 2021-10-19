import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
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
      child: Text('tab2'),
      color: Colors.black87,
    );
  }
}
