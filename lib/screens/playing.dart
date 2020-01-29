import 'dart:async';
import 'dart:io';


import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musica/models/theme_provider.dart';
import 'package:musica/utils/theme.dart';
import '../utils/player_controls.dart';
import 'package:provider/provider.dart';
import '../models/songs.dart';




class Playing extends StatefulWidget {
  static const id = 'playingroute';
  
  final AudioPlayer audioPlayer;
  
  

  Playing({Key key, this.audioPlayer}) : super(key: key);

  @override
  _PlayingState createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  var height;
  var songData;
  var songDataNoListen;
  Icon icon;
  Icon iconPause = Icon(Icons.pause_circle_filled);
  Icon iconPlay = Icon(Icons.play_circle_filled);
  Duration _duration = Duration();
  Duration _position = Duration();
  double seekValue;
  var playlist;
  bool repeat;
  bool shuffle;
  var favoritelist;
  var themeNotifier;







  Future<void> _asyncPlaylistDialog(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select playlist'),
            children: playlist.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 25.0),
                      child: (Text('No playlist found')),
                    )
                  ]
                : [
                    ...(playlist.map((item) {
                      return SimpleDialogOption(
                        onPressed: () {
                        !item.values.toList()[0].contains(
                                      songDataNoListen.currentSong) ?
                                    songDataNoListen.addToPlayList(songDataNoListen.currentSong, item) : songDataNoListen.removeFromPlayList(songDataNoListen.currentSong, item);
                                
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              item.values.toList()[0].contains(
                                      songDataNoListen.currentSong)
                                  ? Icon(Icons.playlist_add_check,
                                      color: Colors.lightBlueAccent)
                                  : Icon(Icons.playlist_add, color: Colors.grey),
                              SizedBox(width: 14.0),
                              Text(item.keys.toList()[0], style: TextStyle(fontSize: 16.0 )),
                            ],
                          ),
                        ),
                      );
                    }).toList())
                  ],
          );
        });
  }





  @override
  void initState() {
    super.initState();
    
  // if (Theme.of(context).platform == TargetPlatform.iOS) {
  //       // set atleast title to see the notification bar on ios.
  //       widget.audioPlayer.setNotification(
  //           title: songData.currentSong.title,
  //           artist: songData.currentSong.artist,
  //           imageUrl: songData.currentSong.albumArt,
  //           forwardSkipInterval: const Duration(seconds: 30), // default is 30s
  //           backwardSkipInterval: const Duration(seconds: 30), // default is 30s
  //           duration: _duration,
  //           elapsedTime: Duration(seconds: 0));
  //     }

    


 
 widget.audioPlayer.onDurationChanged.listen((Duration d) {
    
    setState(() => _duration = d);
  });

    

widget.audioPlayer.onAudioPositionChanged.listen((Duration  p) {
    
    setState(() => _position = p);
  });


widget.audioPlayer.onPlayerCompletion.listen((event) async {
    
    setState(() {
      _position = _duration;
    
        songData.audioPlayerState = AudioPlayerState.COMPLETED;
      });
      if (shuffle) {
        songDataNoListen.currentSong = songData.randomSong(songDataNoListen.listLength, songDataNoListen.listType);
      } 
      else if (repeat) {
        songDataNoListen.currentSong = songDataNoListen.currentSong;
      }
      else {
        
        songDataNoListen.currentSong = songData.nextSong(songDataNoListen.listLength, songDataNoListen.listType);
      }

  
      int result = await PlayerControls.playSong(
          songDataNoListen.currentSong, songDataNoListen.currentSong.filePath, widget.audioPlayer);

      if (result == 1) {
        songDataNoListen.audioPlayerState = widget.audioPlayer.state;
      }
    });


    
   
  }

  

  String getDuration(int duration) {
    final double _temp = (duration / 1000);
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }



  



  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    songData = Provider.of<SongData>(context);

    songDataNoListen = Provider.of<SongData>(context, listen: false);
    playlist = songData.playlistBox.getAt(0) ?? [];
    repeat = songData.settingsBox.get('repeat') ?? false;
    shuffle = songData.settingsBox.get('shuffle') ?? false;
    favoritelist = songData.favoritesBox.get(0) ?? [];
    themeNotifier = Provider.of<ThemeNotifier>(context);


    return songDataNoListen.currentSong == null &&
            songDataNoListen.audioPlayerState == null
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: Text(
              'No song currently playing',
              style: TextStyle(fontSize: 16.0),
            )),
            SizedBox(
              height: 15.0,
            ),
            Center(
                child: Icon(
              Icons.music_note,
              color: Colors.lightBlueAccent,
              size: 24.0,
            )),
          ])
        : SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          PopupMenuButton(
                            onSelected: (_) {},
                            icon: Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.playlist_add),
                                  title: Text('Add to playlist'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _asyncPlaylistDialog(context);
                                    
                                          },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 14.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: height / 3,
                        child: RadialSeekBar(
                          progress: _position != null && _duration != null
                              ? _position.inMilliseconds.toDouble() /
                                  _duration.inMilliseconds.toDouble()
                              : 0.0,
                          seekPercent: seekValue != null ? seekValue : 0.0,
                          trackColor: Colors.grey,
                          trackWidth: 1.0,
                          progressColor: Colors.lightBlueAccent,
                          progressWidth: 4.0,
                          seekColor: Colors.grey,
                          seekWidth: 1.0,
                          thumb: CircleThumb(
                            color: Colors.lightBlueAccent,
                            diameter: 16.0,
                          ),
                          thumbPercent: seekValue != 1.0
                              ? _position.inMilliseconds.toDouble() /
                                  _duration.inMilliseconds.toDouble()
                              : null,
                          onDragUpdate: (double value) async {
                            setState(() {
                              seekValue = value;
                              final seekMilli =
                                  (_duration.inMilliseconds * seekValue)
                                      .round();

                              widget.audioPlayer
                                  .seek(Duration(milliseconds: seekMilli));
                            });
                          },
                          centerContent: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: songDataNoListen
                                          .currentSong.albumArtwork !=
                                      null
                                  ? FileImage(
                                      File(songData.currentSong.albumArtwork))
                                  : AssetImage(
                                      'assets/images/placeholder.jpg',
                                    ),
                              radius: 100,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "${getDuration(_position.inMilliseconds.round())}  /  ${getDuration(_duration.inMilliseconds.round())}",
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.repeat),
                                      iconSize: 24.0,
                                      onPressed: () {
                                        bool value = repeat;
                                        songDataNoListen.repeat = !value;
                                        repeat = !value;
                                        Scaffold.of(context).hideCurrentSnackBar();

                                        Scaffold.of(context).showSnackBar(SnackBar(
                                        content: repeat ? Text("Repeat on") : Text("Repeat off"),
                                        ));
                                         repeat ? songDataNoListen.shuffle = false : songDataNoListen.shuffle = shuffle;
                                      },
                                      color: repeat
                                          ? Colors.lightBlueAccent
                                          : themeNotifier.theme == darkTheme ? Colors.white : Colors.black54,
                                    ),
                                    IconButton(
                                      icon: favoritelist
                                              .contains(
                                                  songDataNoListen.currentSong)
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border),
                                      iconSize: 24.0,
                                      onPressed: () {

                                        Scaffold.of(context).hideCurrentSnackBar();

                                        Scaffold.of(context).showSnackBar(SnackBar(
                                        content: favoritelist
                                              .contains(
                                                  songDataNoListen.currentSong)
                                          ? Text("Removed from favorites") : Text("Added to favorites"),
                                        ));

                                        songDataNoListen.addToFavorites(
                                            songDataNoListen.currentSong);

                                        
                                      },
                                      color: favoritelist
                                              .contains(
                                                  songDataNoListen.currentSong)
                                          ? Colors.red
                                          : themeNotifier.theme == darkTheme ? Colors.white : Colors.black54,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.shuffle),
                                      iconSize: 24.0,
                                      onPressed: () {
                                        bool value = shuffle;
                                        songDataNoListen.shuffle = !value;
                                        shuffle = !value;
                                       
                                         Scaffold.of(context).hideCurrentSnackBar();

                                        Scaffold.of(context).showSnackBar(SnackBar(
                                        content: shuffle ? Text("Shuffle on") : Text("Shuffle off"),
                                        ));

                                         shuffle ? songDataNoListen.repeat = false : songDataNoListen.repeat = repeat;
                                      },
                                      color: shuffle
                                          ? Colors.lightBlueAccent
                                          : themeNotifier.theme == darkTheme ? Colors.white : Colors.black54,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    songDataNoListen.currentSong.title,
                                    style: TextStyle(fontSize: 20.0),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    songDataNoListen.currentSong.artist,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      letterSpacing: 2.0,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.skip_previous),
                                      iconSize: 30.0,
                                      onPressed: () async {
                                        if (shuffle) {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.randomSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        } else {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.prevSong(songDataNoListen.listType);
                                        }

                                        int result =
                                            await PlayerControls.playSong(
                                                songDataNoListen.currentSong,    
                                                songDataNoListen
                                                    .currentSong.filePath,
                                                widget.audioPlayer);

                                        if (result == 1) {
                                          songDataNoListen.audioPlayerState =
                                            widget.audioPlayer.state;
                                            
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    IconButton(
                                      icon: icon = songData.audioPlayerState ==
                                              AudioPlayerState.PLAYING
                                          ? iconPause
                                          : iconPlay,
                                      iconSize: 50.0,
                                      onPressed: () async {
                                        if (songDataNoListen.audioPlayerState ==
                                            AudioPlayerState.PLAYING) {
                                          int result =
                                              await PlayerControls.pauseSong(songDataNoListen.currentSong,
                                                  widget.audioPlayer);

                                          if (result == 1) {
                                            songDataNoListen.audioPlayerState =
                                                widget.audioPlayer.state;
                                          }
                                        } else if (songDataNoListen
                                                .audioPlayerState ==
                                            AudioPlayerState.PAUSED) {
                                          int result =
                                              await PlayerControls.resumeSong(songDataNoListen.currentSong,
                                                  widget.audioPlayer);

                                          if (result == 1) {
                                            songDataNoListen.audioPlayerState =
                                                widget.audioPlayer.state;
                                          }
                                        } else {
                                          int result =
                                              await PlayerControls.playSong(songDataNoListen.currentSong,
                                                  songData.currentSong.filePath,
                                                  widget.audioPlayer);

                                          if (result == 1) {
                                            songDataNoListen.audioPlayerState =
                                                widget.audioPlayer.state;
                                          }
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_next),
                                      iconSize: 30.0,
                                      onPressed: () async {
                                        if (shuffle) {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.randomSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        } else {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.nextSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        }

                                        int result =
                                            await PlayerControls.playSong(songDataNoListen.currentSong,
                                                songDataNoListen
                                                    .currentSong.filePath,
                                                widget.audioPlayer);

                                        if (result == 1) {
                                          songDataNoListen.audioPlayerState =
                                              widget.audioPlayer.state;
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}



