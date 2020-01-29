import 'package:flutter/material.dart';

import '../widgets/list.dart';


class AllSongs extends StatefulWidget {
  static const id = 'allsongsroute';
  final audioPlayer;
  

  AllSongs({Key key, this.audioPlayer}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {


  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
                     'All songs',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
          ),
          Expanded(child: SongListView(audioPlayer: widget.audioPlayer)),
        ],
      ),
    );
  }
}
