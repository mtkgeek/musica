
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

import 'package:musica/models/songs.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musica/utils/player_controls.dart';
import '../utils/theme.dart';


import 'package:musica/models/theme_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'all_songs.dart';
import 'playing.dart';
import 'playlist.dart';
import 'favorites.dart';

 


AudioPlayer audioPlayer = AudioPlayer();

  


void playNext(var songDataNoListen, AudioPlayer audioPlayer) async {
     if (songDataNoListen.shuffle) {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.randomSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        } else {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.nextSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        }

                                        int result =
                                            await PlayerControls.playSong(
                                                 songDataNoListen
                                                    .currentSong,   
                                                songDataNoListen
                                                    .currentSong.filePath,
                                                audioPlayer);

                                        if (result == 1) {
                                          songDataNoListen.audioPlayerState =
                                            audioPlayer.state;
                                            
                                        }
}
 

 void playPrev(var songDataNoListen, AudioPlayer audioPlayer) async {
     if (songDataNoListen.shuffle) {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.randomSong(songDataNoListen.listLength, songDataNoListen.listType);
                                        } else {
                                          songDataNoListen.currentSong =
                                              songDataNoListen.prevSong(songDataNoListen.listType);
                                        }

                                        int result =
                                            await PlayerControls.playSong(
                                                songDataNoListen
                                                    .currentSong,    
                                                songDataNoListen
                                                    .currentSong.filePath,
                                                audioPlayer);

                                        if (result == 1) {
                                          songDataNoListen.audioPlayerState =
                                            audioPlayer.state;
                                            
                                        }
 }



void changePlayState(var songDataNoListen) {
  songDataNoListen.audioPlayerState = audioPlayer.state;
 print(songDataNoListen.audioPlayerState);
}


class Base extends StatefulWidget {
  static const id = 'baseroute';
 

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int selectedPos = 0;
 
var songDataNoListen;  

  var songData;

  var themeNotifier;

  CircularBottomNavigationController _navigationController;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue),
    new TabItem(Icons.music_note, "Songs", Colors.orange),
    new TabItem(Icons.play_arrow, "Playing", Colors.red),
    new TabItem(Icons.list, "Playlist", Colors.cyan),
    new TabItem(Icons.favorite, "Favorites", Colors.indigo),
  ]);

  List<Widget> _widgetOptions = <Widget>[
    Home(
      key: PageStorageKey('home'),
    ),
    AllSongs(
     
     audioPlayer: audioPlayer, 
      key: PageStorageKey('allsongs'),
    ),
    Playing(
     audioPlayer: audioPlayer,
      key: PageStorageKey('playing'),
    ),
    Playlist(
   audioPlayer: audioPlayer,
      key: PageStorageKey('playlist'),
    ),
    Favorites(
    audioPlayer: audioPlayer,
      key: PageStorageKey('favorites'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
    
  }



 

  

  @override
  Widget build(BuildContext context) {
  
    songDataNoListen = Provider.of<SongData>(context, listen: false);
    songData = Provider.of<SongData>(context);
    themeNotifier = Provider.of<ThemeNotifier>(context);
   
    return 
      Scaffold(
    
        
                                      body: IndexedStack(
                    index: _navigationController.value,
                    children: _widgetOptions,
                ),
          
        bottomNavigationBar: CircularBottomNavigation(
          
          tabItems,
          barHeight: 65.0,
          circleSize: 45.0,

          circleStrokeWidth: 1,
          barBackgroundColor: themeNotifier.theme == darkTheme ? Colors.black12 : Colors.white,
          normalIconColor: themeNotifier.theme == darkTheme ? Colors.white : Colors.black54,
          iconsSize: 20.0,
          controller: _navigationController,
          selectedCallback: (int selectedPos) {
            setState(() {
              this.selectedPos = selectedPos;
               
            });
          },
        ),
      
    );
  }
}
