import 'dart:async';
import 'dart:isolate';
import 'dart:ui';


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';




class PlayerControls {

  static Future<int> playSong(var songData, var filePath, var audioPlayer) async {
    int result;
    int stopped = await audioPlayer.stop();

    if (stopped == 1) {
      result = await audioPlayer.play(filePath, isLocal: true);
     
       MediaNotification.showNotification(
                        title: songData == null ? 'Nothing Playing' : songData.title, author: songData == null ? 'No artist' : songData.artist);
    
      
     


    }
    return result;
  }

  static Future<int> pauseSong(var songData, var audioPlayer) async {
    int result;
    
      result = await audioPlayer.pause();
      
   MediaNotification.showNotification(
                        title: songData == null ? 'Nothing Playing' : songData.title, author: songData == null ? 'No artist' : songData.artist, isPlaying : false);
    return result;
  }

  static Future<int> resumeSong(var songData, var audioPlayer) async {
    int result;
    
      result = await audioPlayer.resume();
        MediaNotification.showNotification(
                        title: songData == null ? 'Nothing Playing' : songData.title, author: songData == null ? 'No artist' : songData.artist);
    
      
  
    return result;
  }

  static Future<int> stopSong(var audioPlayer) async {
    int result;
    
      result = await audioPlayer.stop();
     MediaNotification.hideNotification();
 
    return result;
  }
}