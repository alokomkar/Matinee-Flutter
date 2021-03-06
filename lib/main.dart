import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/api/function.dart';
import 'package:movies/bloc/change_theme_bloc.dart';
import 'package:movies/bloc/change_theme_state.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/movie_detail.dart';
import 'package:movies/screens/search_view.dart';
import 'package:movies/screens/settings.dart';
import 'package:movies/screens/widgets/discover_movies_widget.dart';
import 'package:movies/screens/widgets/scrolling_movies_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matinee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue, canvasColor: Colors.transparent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Genres> _genres;

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres;
    });
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(state),
          drawer: Drawer(
            child: SettingsPage(),
          ),
          body: _buildMainContainer(state),
        );
      },
    );


  AppBar _buildAppBar(ChangeThemeState state) => AppBar(
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        color: state.themeData.accentColor,
      ),
      onPressed: () {
        _scaffoldKey.currentState.openDrawer();
      },
    ),
    centerTitle: true,
    title: Text(
      'Matinee',
      style: state.themeData.textTheme.headline,
    ),
    backgroundColor: state.themeData.primaryColor,
    actions: <Widget>[
      IconButton(
        color: state.themeData.accentColor,
        icon: Icon(Icons.search),
        onPressed: () async {
          if (_genres != null) {
            final Movie result = await showSearch(
                context: context,
                delegate: MovieSearch(
                    themeData: state.themeData, genres: _genres));
            if (result != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                          movie: result,
                          themeData: state.themeData,
                          genres: _genres,
                          heroId: '${result.id}search')));
            }
          }
        },
      )
    ],
  );

  Container _buildMainContainer(ChangeThemeState state) => Container(
    color: state.themeData.primaryColor,
    child: _buildListView(state),
  );

  ListView _buildListView(ChangeThemeState state) => ListView(
    physics: BouncingScrollPhysics(),
    children: <Widget>[
      DiscoverMovies(
        themeData: state.themeData,
        genres: _genres,
      ),
      ScrollingMovies(
        themeData: state.themeData,
        title: 'Top Rated',
        api: Endpoints.topRatedUrl(1),
        genres: _genres,
      ),
      ScrollingMovies(
        themeData: state.themeData,
        title: 'Now Playing',
        api: Endpoints.nowPlayingMoviesUrl(1),
        genres: _genres,
      ),
      // ScrollingMovies(
      //   themeData: state.themeData,
      //   title: 'Upcoming Movies',
      //   api: Endpoints.upcomingMoviesUrl(1),
      //   genres: _genres,
      // ),
      ScrollingMovies(
        themeData: state.themeData,
        title: 'Popular',
        api: Endpoints.popularMoviesUrl(1),
        genres: _genres,
      ),
    ],
  );

}
