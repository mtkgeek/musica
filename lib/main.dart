
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import 'package:musica/models/theme_provider.dart';
import 'package:musica/screens/favorites.dart';
import 'package:musica/utils/player_controls.dart';



import 'package:provider/provider.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import './screens/base.dart';
import './screens/home.dart';
import './screens/all_songs.dart';
import './screens/playing.dart';
import './screens/playlist.dart';
import './utils/theme.dart';

import './models/songs.dart';
import './models/flutter_audio_query_adapter.dart';



  List<SongInfo> songs;
  List<AlbumInfo> albumList;
 var sDataNoListen;  
var sData;





Future initAudioPlayer() async {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

    try {
      songs = await audioQuery.getSongs();
      albumList = await audioQuery.getAlbums();
    } catch (e) {
      print("Failed to get songs: '${e.message}'.");
    }
  
    
if(songs != null && albumList != null) {
 
  sDataNoListen.songs = songs;
  sDataNoListen.albums = albumList;
  
  sDataNoListen.isLoading = false;

}
    
  
  
  }

void main() async {
  
  initAudioPlayer(); 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(SongDataAdapter(), 1);
  Hive.registerAdapter(SongInfoAdapter(), 2);
  await Hive.openBox('settings');
  await Hive.openBox('playlist');
  await Hive.openBox('favorites');
  await Hive.openBox('theme');

 

  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider.value(
    value: ThemeNotifier(),
        ),
    ChangeNotifierProvider.value(
          value: SongData(songs, albumList),
        ),
      ],
      child: MyApp(),
    
  ));
}


 




class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();
    
    MediaNotification.setListener('pause', () async {
      
       int result = await PlayerControls.pauseSong(sDataNoListen.currentSong, audioPlayer);
        if(result == 1) {changePlayState(sDataNoListen);} 
      
      
    });

    MediaNotification.setListener('play', () async {
     
        int result = await PlayerControls.resumeSong(sDataNoListen.currentSong, audioPlayer);
        if(result == 1) {changePlayState(sDataNoListen);} 
    
      
    });

    MediaNotification.setListener('next', () { playNext(sDataNoListen, audioPlayer); });

    MediaNotification.setListener('prev', () { playPrev(sDataNoListen, audioPlayer); });               
    
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
    
  }


var themeNotifier;
 

  

  @override
  Widget build(BuildContext context) {
    sData = Provider.of<SongData>(context);
    sDataNoListen = Provider.of<SongData>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context);
    
    
    return MaterialApp(
        title: 'Musica',
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.darkOn ? darkTheme : lightTheme,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: sData.isLoading
              ? Center(
                  child: Image.asset(
                    'assets/images/Musepng.png',
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 150.0,
                  ),
                )
              : Base(),
        ),
        routes: {
          Base.id: (context) => Base(),
          Home.id: (context) => Home(),
          AllSongs.id: (context) => AllSongs(),
          Playing.id: (context) => Playing(),
          Playlist.id: (context) => Playlist(),
          Favorites.id: (context) => Favorites(),
        },
      
    );
  }
}
