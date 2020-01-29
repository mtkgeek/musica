
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import '../utils/player_controls.dart';
import 'package:provider/provider.dart';

import '../models/songs.dart';
import 'avatar.dart';

class SongListView extends StatefulWidget {
  final audioPlayer;
 
  SongListView({@required this.audioPlayer});
  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {

  var songData;
  int result;
  var songDataNoListen;

  Icon icon2 = Icon(
    Icons.pause,
    color: Colors.white,
  );
  Icon icon3 = Icon(
    Icons.play_arrow,
    color: Colors.white,
  );

  Icon icon1 = Icon(
    Icons.music_note,
    color: Colors.lightBlueAccent,
    size: 30.0,
  );

  Widget leading(var title, var color, var s) {
    if (songDataNoListen.audioPlayerState == AudioPlayerState.PLAYING &&
        songDataNoListen.currentSong == s) {
      return avatar(title, color, icon2);
    } else if (songDataNoListen.audioPlayerState == AudioPlayerState.PAUSED &&
        songDataNoListen.currentSong == s) {
      return avatar(title, color, icon3);
    } else {
      return icon1;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    songData = Provider.of<SongData>(context);

    songDataNoListen = Provider.of<SongData>(context, listen: false);
    return Scrollbar(
      child: ListView.builder(
      controller: songDataNoListen.controller,
        itemCount: songDataNoListen.length,
        itemBuilder: (context, int index) {
          final s = songDataNoListen.songs[index];
          final Color color = Colors.blue;

          return Container(
            height: 75.0,
            child: ListTile(
              dense: false,
              leading: leading(s.title, color, s),
              title: Text(s.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
              subtitle: Text(
                "By ${s.artist}",
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
              onTap: () async {
                
               
                if (songDataNoListen.audioPlayerState ==
                        AudioPlayerState.PLAYING &&
                    songDataNoListen.currentSong == s) {
                  int result = await PlayerControls.pauseSong(s, widget.audioPlayer);
                  if (result == 1) {
                    songDataNoListen.audioPlayerState = widget.audioPlayer.state;
                  }
                } else if (songDataNoListen.audioPlayerState ==
                        AudioPlayerState.PAUSED &&
                    songDataNoListen.currentSong == s) {
                  int result =
                      await PlayerControls.resumeSong(s, widget.audioPlayer);
                  if (result == 1) {
                    songDataNoListen.audioPlayerState = widget.audioPlayer.state;
                  }
                } else {
                  songDataNoListen.listType = songDataNoListen.songs;
                  songDataNoListen.listLength = songDataNoListen.length;
                  int result = await PlayerControls.playSong(s,
                     s.filePath, widget.audioPlayer);
                  if (result == 1) {
                    songDataNoListen.currentSongIndex = index;
                    songDataNoListen.currentSong = s;
                    
                    songDataNoListen.audioPlayerState = widget.audioPlayer.state;

                   
    
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
