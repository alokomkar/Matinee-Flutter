import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/api/function.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';

import '../movie_detail.dart';

class DiscoverMovies extends StatefulWidget {
  final ThemeData themeData;
  final List<Genres> genres;
  DiscoverMovies({this.themeData, this.genres});
  @override
  _DiscoverMoviesState createState() => _DiscoverMoviesState();
}

class _DiscoverMoviesState extends State<DiscoverMovies> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.discoverMoviesUrl(1)).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Text('Discover', style: widget.themeData.textTheme.headline),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: moviesList == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Swiper(
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                                movie: moviesList[index],
                                themeData: widget.themeData,
                                genres: widget.genres,
                                heroId:
                                '${moviesList[index].id}discover')));
                  },
                  child: Hero(
                    tag: '${moviesList[index].id}discover',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        image: NetworkImage(TMDB_BASE_IMAGE_URL +
                            'w500/' +
                            moviesList[index].posterPath),
                        fit: BoxFit.cover,
                        placeholder:
                        AssetImage('assets/images/loading.gif'),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: moviesList.length,
            viewportFraction: 0.7,
            scale: 0.9,
          ),
        ),
      ],
    );
  }
}