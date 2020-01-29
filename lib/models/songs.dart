import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';

part 'songs.g.dart';




@HiveType()
class SongData with ChangeNotifier {
 
 
 var _settingsBox = Hive.box('settings');
 var _playlistBox = Hive.box('playlist');
 var _favoritesBox = Hive.box('favorites');

 @HiveField(0)
 List _songs = [];

 @HiveField(1)
 List _favoriteSongs;

@HiveField(2)
 List _playList;
 
@HiveField(3)
 List<AlbumInfo> _albums  = [];

@HiveField(4)
 SongInfo _currentSong;

 String _notificationStatus = 'hidden';
 int _listLength;
 List _listType;
 int _currentSongIndex;
 AudioPlayerState _audioPlayerState;
 bool _shuffle;
 bool _repeat;
 bool _isLoading = true;
 ScrollController _controller = ScrollController();



  SongData(this._songs, this._albums);// constructor

  List get songs => _songs;
  List<AlbumInfo> get albums => _albums; 
  int get length => _songs.length;
  int get albumsLength => _albums.length;
  bool get shuffle => _shuffle = _settingsBox.get('shuffle') ?? false;
  bool get repeat => _repeat = _settingsBox.get('repeat') ?? false;
  bool get isLoading => _isLoading;
  int get songNumber => _currentSongIndex + 1;
  AudioPlayerState get audioPlayerState => _audioPlayerState;
  
  
  int get currentSongIndex => _currentSongIndex;
  SongInfo get currentSong => _currentSong;
  String get notificationStatus => _notificationStatus;
  ScrollController get controller => _controller;
  int get listLength => _listLength;
  List get listType => _listType;
  Box get favoritesBox => _favoritesBox;
  Box get playlistBox => _playlistBox;
  Box get settingsBox => _settingsBox;


  SongInfo nextSong(int listLength, List listType) {
    if (_currentSongIndex < listLength) {
      _currentSongIndex++;
      _controller.jumpTo(75.0 * _currentSongIndex);
    }
    if (_currentSongIndex >= listLength) {
       _currentSongIndex = 0;
    }
    return listType[_currentSongIndex];// problem
   
  }

  SongInfo randomSong(int listLength, List listType) {
    Random r = new Random();
    _currentSongIndex = r.nextInt(listLength);
    _controller.jumpTo(75.0 * _currentSongIndex);
    return listType[_currentSongIndex];
  }

  SongInfo prevSong(List listType) {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
      _controller.jumpTo(75.0 * _currentSongIndex);
    }
    if (_currentSongIndex < 0) {
       _currentSongIndex = listType.length;
    }
    return listType[_currentSongIndex];
  }

  

set notificationStatus(String value) {
    _notificationStatus = value;
    notifyListeners();
  }


set audioPlayerState(AudioPlayerState value) {
    _audioPlayerState = value;
    notifyListeners();
  }

set listLength(int value) {
    _listLength = value;
    notifyListeners();
  }

set listType(List value) {
    _listType = value;
    notifyListeners();
  }

  set currentSong(SongInfo value) {
    _currentSong = value;
    notifyListeners();
  }

set currentSongIndex(int value) {
    _currentSongIndex = value;
    notifyListeners();
  }
  
set shuffle(bool value) {
  _shuffle = value;
  _settingsBox.put('shuffle', _shuffle);
  notifyListeners();
}

set isLoading(bool value) {
  _isLoading = value;
  
  notifyListeners();
}


set songs(List value) {
  _songs = value;
  
  notifyListeners();
}

set albums(List<AlbumInfo> value) {
  _albums = value;
  
  notifyListeners();
}


set repeat(bool value) {
  _repeat = value;
  _settingsBox.put('repeat', _repeat);
  notifyListeners();
}
//playlist logic

void createPlayList(Map value) {
  _playList = _playlistBox.get(0) ?? [];
   _playList.add(value);
  _playlistBox.put(0, _playList); //add to database
  notifyListeners();
}

void deletePlayList(Map value) {
  _playList = _playlistBox.get(0) ?? [];
 _playList.remove(value);
  _playlistBox.put(0, _playList);  //remove from database
  notifyListeners();
}

void addToPlayList(SongInfo song, Map playListItem) {
  _playList = _playlistBox.get(0) ?? [];
  int listIndex = _playList.indexOf(playListItem);
  _playList[listIndex].values.toList()[0].add(song);
  
 _playlistBox.put(0, _playList);
  
   notifyListeners();
}

void removeFromPlayList(SongInfo song, Map playListItem) {
  _playList = _playlistBox.get(0) ?? [];
  int listIndex = _playList.indexOf(playListItem);
  _playList[listIndex].values.toList()[0].remove(song);
  
 _playlistBox.put(0, _playList);
  
   notifyListeners();
 
}


//favorite list logic
void addToFavorites(SongInfo song) {
  _favoriteSongs = _favoritesBox.get(0) ?? [];
  if(_favoriteSongs.contains(song)) {
    _favoriteSongs.remove(song);
    _favoritesBox.put(0, _favoriteSongs);
    

  } else {
    _favoriteSongs.add(song);
    _favoritesBox.put(0, _favoriteSongs);
 
  }
  print(_favoriteSongs);
 notifyListeners(); 
  
}

void removeFromFavorites(SongInfo song) {
  
    _favoriteSongs.remove(song);

  _favoritesBox.put(0, _favoriteSongs);
  
  notifyListeners();
}

void undoRemoval(int index, SongInfo song){
  /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
  
    _favoriteSongs.insert(index, song);
  _favoritesBox.put(0, _favoriteSongs);
    notifyListeners();
 
}
  
}
