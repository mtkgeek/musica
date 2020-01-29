import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import 'package:musica/models/theme_provider.dart';
import 'package:musica/screens/playlist.dart';
import 'package:musica/utils/theme.dart';
import '../utils/player_controls.dart';
import 'package:provider/provider.dart';

import '../models/songs.dart';
import '../widgets/avatar.dart';

class PlaylistSongs extends StatefulWidget {
  static const id = 'playlistSongsroute';
  

  PlaylistSongs({Key key}) : super(key: key);

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {

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

    Widget stackBehindDismiss() {
  return Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20.0),
    color: Colors.red,
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
} 

  @override
  Widget build(BuildContext context) {

    final Playlist args = ModalRoute.of(context).settings.arguments;

    final singlePlaylist = args.playlistItem;

    

    final audioPlayer = args.audioPlayer;

  

    songData = Provider.of<SongData>(context);
    songDataNoListen = Provider.of<SongData>(context, listen: false);
  final themeNotifier = Provider.of<ThemeNotifier>(context);    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: themeNotifier.theme == darkTheme ? IconThemeData(color: Colors.white) : IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
                         singlePlaylist.keys.toList()[0],
                         
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: themeNotifier.theme == darkTheme ? Colors.white : Colors.black),
                        ),
      ),
          body: singlePlaylist.values.toList()[0].isEmpty ?  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Text(
                'No song in this playlist',
                style: TextStyle(fontSize: 16.0),
              )),
              SizedBox(
                height: 15.0,
              ),
              Center(
                  child: Icon(
                Icons.list,
                color: Colors.lightBlueAccent,
                size: 24.0,
              )),
            ]) : SafeArea(
        child: Column(
          children: <Widget>[
            
            Expanded(child: Scrollbar(
        child: ListView.builder(
        controller: songDataNoListen.controller,
          itemCount: singlePlaylist.values.toList()[0].length,
          itemBuilder: (context, int index) {

            final s = singlePlaylist.values.toList()[0][index];
            final Color color = Colors.blue;

            return Dismissible(
              background: stackBehindDismiss(),
              key: ObjectKey(s),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                songDataNoListen.removeFromPlayList(s, singlePlaylist);

                Scaffold.of(context).hideCurrentSnackBar();

                // undo removal
                Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Song removed from ${singlePlaylist.keys.toList()[0]}"),
                ));
                
              },
              child: Container(
              height: 75.0,
              child: ListTile(
                dense: false,
                leading: leading('${s.title}', color, s),
                title: Text('${s.title}', maxLines: 2, overflow: TextOverflow.ellipsis,),
                subtitle: Text(
                  "By ${s.artist}",
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
                onTap: () async {

                
               
                  if (songDataNoListen.audioPlayerState ==
                          AudioPlayerState.PLAYING &&
                      songData.currentSong == s) {
                    int result = await PlayerControls.pauseSong(s, audioPlayer);
                    if (result == 1) {
                      songDataNoListen.audioPlayerState = audioPlayer.state;
                    }
                  } else if (songDataNoListen.audioPlayerState ==
                          AudioPlayerState.PAUSED &&
                      songData.currentSong == s) {
                    int result =
                        await PlayerControls.resumeSong(s, audioPlayer);
                    if (result == 1) {
                      songDataNoListen.audioPlayerState = audioPlayer.state;
                    }
                  } else {
                    songDataNoListen.listType = singlePlaylist.values.toList()[0];
                  songDataNoListen.listLength = singlePlaylist.values.toList()[0].length;
                    int result = await PlayerControls.playSong(
                      s, s.filePath, audioPlayer);
                    if (result == 1) {
                       songDataNoListen.currentSongIndex = index;   
                      songDataNoListen.currentSong = s;
                      
                      songDataNoListen.audioPlayerState = audioPlayer.state;
                      
                   songDataNoListen.notificationStatus = 'play';
                   MediaNotification.showNotification(
                        title: songData == null ? 'Nothing Playing' : songData.currentSong.title, author: songData == null ? 'No artist' : songData.currentSong.artist);
    
    
                    }
                  }
                },
              ),
              ),
            );
          },
        ),
      ), 
        ),
          ],
        ),
      ),
    );
    
        
          
  }
}
