import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:practica2/src/models/popular_movies_model.dart';

class CardPopularView extends StatelessWidget {
  final PopularMoviesModel popular;
  const CardPopularView({Key? key, required this.popular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.only(top: 10.0, left: 7, right: 7, bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Hero(
            tag: popular.id.toString(),
            child: Container(
                child: /*CachedNetworkImage(
              imageUrl:
                  'https://image.tmdb.org/t/p/w500${popular.backdropPath}',
              imageBuilder: (context, imageProvider) => Container(
                width: 300,
                //height: 300,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 5),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                child: Icon(
                  Icons.error,
                  color: Colors.white70,
                ),
              ),
            )*/
                    Image(
              image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500/${popular.backdropPath}'),
              //fadeInDuration: Duration(milliseconds: 400)
            )),
          ),
          Opacity(
            opacity: .5,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              height: 55.0,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    popular.title!,
                    style: TextStyle(color: Colors.amber[600], fontSize: 12.0),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detail',
                          arguments: popular);
                    },
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
