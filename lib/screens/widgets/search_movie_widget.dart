import 'package:flutter/material.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/api/function.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';

class SearchMovieWidget extends StatefulWidget {
  final ThemeData themeData;
  final String query;
  final List<Genres> genres;
  final Function(Movie) onTap;
  SearchMovieWidget({this.themeData, this.query, this.genres, this.onTap});
  @override
  _SearchMovieWidgetState createState() => _SearchMovieWidgetState();
}

class _SearchMovieWidgetState extends State<SearchMovieWidget> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.movieSearchUrl(widget.query)).then((value) {
      print(value.length);
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor,
      child: moviesList == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : moviesList.length == 0
          ? Center(
        child: Text(
          "Oops! couldn't find the movie",
          style: widget.themeData.textTheme.body2,
        ),
      )
          : ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: moviesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                widget.onTap(moviesList[index]);
              },
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: moviesList[index].posterPath == null
                              ? Image.asset(
                            'assets/images/na.jpg',
                            fit: BoxFit.cover,
                          )
                              : FadeInImage(
                            image: NetworkImage(
                                TMDB_BASE_IMAGE_URL +
                                    'w500/' +
                                    moviesList[index]
                                        .posterPath),
                            fit: BoxFit.cover,
                            placeholder: AssetImage(
                                'assets/images/loading.gif'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                moviesList[index].title,
                                style:
                                widget.themeData.textTheme.body1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    moviesList[index].voteAverage,
                                    style: widget
                                        .themeData.textTheme.body2,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.green)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(
                      color: widget.themeData.accentColor,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}