import 'package:flutter/material.dart';
import '../widgets/favorite_list.dart';
import 'package:provider/provider.dart';

import '../models/songs.dart';

class Favorites extends StatefulWidget {

  static const id = 'favoritesroute';
  final audioPlayer;

  Favorites({Key key, this.audioPlayer}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);
    var favoritelist = songData.favoritesBox.get(0) ?? [];  

    return favoritelist.isEmpty ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: Text(
              'No favorite songs',
              style: TextStyle(fontSize: 16.0),
            )),
            SizedBox(
              height: 15.0,
            ),
            Center(
                child: Icon(
              Icons.favorite,
              color: Colors.lightBlueAccent,
              size: 24.0,
            )),
          ]) : SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
                     'Favorite songs',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
          ),
         Expanded(child: FavoriteSongListView(audioPlayer: widget.audioPlayer,)),
        ],
      ),
    );
  }
}