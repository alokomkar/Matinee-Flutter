import 'package:flutter/material.dart';
import 'package:movies/api/function.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/credits.dart';
import 'package:movies/screens/castncrew.dart';

class ScrollingArtists extends StatefulWidget {
  final ThemeData themeData;
  final String api, title, tapButtonText;
  final Function(Cast) onTap;
  ScrollingArtists(
      {this.themeData, this.api, this.title, this.tapButtonText, this.onTap});
  @override
  _ScrollingArtistsState createState() => _ScrollingArtistsState();
}

class _ScrollingArtistsState extends State<ScrollingArtists> {
  Credits credits;
  @override
  void initState() {
    super.initState();
    fetchCredits(widget.api).then((value) {
      setState(() {
        credits = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        credits == null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(widget.title, style: widget.themeData.textTheme.body2),
            ],
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title,
                  style: widget.themeData.textTheme.body2),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CastAndCrew(
                          themeData: widget.themeData,
                          credits: credits,
                        )));
              },
              child: Text(widget.tapButtonText,
                  style: widget.themeData.textTheme.caption),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: credits == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: credits.cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(credits.cast[index]);
                  },
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            width: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child:
                              credits.cast[index].profilePath == null
                                  ? Image.asset(
                                'assets/images/na.jpg',
                                fit: BoxFit.cover,
                              )
                                  : FadeInImage(
                                image: NetworkImage(
                                    TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        credits.cast[index]
                                            .profilePath),
                                fit: BoxFit.cover,
                                placeholder: AssetImage(
                                    'assets/images/loading.gif'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            credits.cast[index].name,
                            style: widget.themeData.textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}