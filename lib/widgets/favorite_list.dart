import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import '../utils/player_controls.dart';
import 'package:provider/provider.dart';

import '../models/songs.dart';
import 'avatar.dart';

class FavoriteSongListView extends StatefulWidget {
  final audioPlayer;
  FavoriteSongListView({@required this.audioPlayer});
  @override
  _FavoriteSongListViewState createState() => _FavoriteSongListViewState();
}

class _FavoriteSongListViewState extends State<FavoriteSongListView> {

  var songData;
  int result;
  var songDataNoListen;
  var favoritelist;

  Icon icon2 = Icon(
    Icons.pause,
    color: Colors.white,
  );
  Icon icon3 = Icon(
    Icons.play_arrow,
    color: Colors.white,
  );

  Icon icon1 = Icon(
    Icons.favorite,
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
    songData = Provider.of<SongData>(context);
    favoritelist = songData.favoritesBox.get(0) ?? [];
    songDataNoListen = Provider.of<SongData>(context, listen: false);

    return Scrollbar(
      child: ListView.builder(
      controller: songDataNoListen.controller,
        itemCount: favoritelist.length,
        itemBuilder: (context, int index) {
          final s = favoritelist[index];
          final MaterialColor color = Colors.blue;

          return Dismissible(
            background: stackBehindDismiss(),
            key: ObjectKey(s),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              songDataNoListen.removeFromFavorites(s);

              Scaffold.of(context).hideCurrentSnackBar();

              // undo removal
              Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Song removed from favorites"),
              action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    //To undo deletion
                    songDataNoListen.undoRemoval(index, s);
                  })));
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
                  songDataNoListen.listType = favoritelist;
                  songDataNoListen.listLength = favoritelist.length;
                  int result = await PlayerControls.playSong(s,
                      s.filePath, widget.audioPlayer);
                  if (result == 1) {
                    songDataNoListen.currentSongIndex = index;
                    songDataNoListen.currentSong = s;
                    
                    songDataNoListen.audioPlayerState = widget.audioPlayer.state;
                    
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
    ); 
          
          
  }
}
