import 'package:flutter/material.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/models/video_movie_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ApiPopular? apiPopular;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    final pelicula =
        ModalRoute.of(context)!.settings.arguments as PopularMoviesModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pelicula.title!,
          style: TextStyle(color: Colors.amber[600]),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black87,
        child: _videoSearch(pelicula.id),
      ),
    );
  }

  _videoSearch(id) {
    return FutureBuilder(
      future: apiPopular!.getVideoById(id.toString()),
      builder: (BuildContext context,
          AsyncSnapshot<List<VideoMovieModel>?> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Hay un error en la peticion'),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            //print(snapshot.data);
            return Text(snapshot.data![0].key.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }
}
