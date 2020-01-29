import 'package:flutter/material.dart';
import 'package:musica/models/theme_provider.dart';
import '../screens/playlist_songs.dart';
import 'package:provider/provider.dart';
import '../utils/player_controls.dart';
import '../models/songs.dart';

class Playlist extends StatefulWidget {

  static const id = 'playlistroute';
  final audioPlayer;
  
  final Map playlistItem;

 

  Playlist({Key key, this.audioPlayer, this.playlistItem}): super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {

var songDataNoListen;
String playlistName;
Map playlist;

  Future<void> _addPlaylistDialog(BuildContext context) async {
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter playlist name'),
        content: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
                
              autofocus: true,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 5, left: 0),
                  hintText: 'Name',),
              onChanged: (value) {
                playlistName = value;
                playlist = {playlistName : []};
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
                
                Navigator.of(context).pop(playlist);
              
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              if(playlistName != null) {
                 
               songDataNoListen.createPlayList(playlist);
        
                Navigator.of(context).pop();
              }

            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    

    var songData = Provider.of<SongData>(context);
    songDataNoListen = Provider.of<SongData>(context, listen: false);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
  var playlist = songData.playlistBox.get(0) ?? [];

    return  MaterialApp(
      title: 'Musica',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.theme,
      routes: {
    
    PlaylistSongs.id: (context) => PlaylistSongs(),
  },
          home: Scaffold(
        body: playlist.isEmpty ?  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Text(
                'No playlist',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                       'Playlist',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
            ),        
           Expanded(child: ListView.builder(
       
          itemCount: playlist.length,
          itemBuilder: (context, int index) {
            final s = playlist[index];
            

            return Column(
              children: <Widget>[
                ListTile(
                  dense: false,
                  leading:   PopupMenuButton(
                              onSelected: (value) async {
                                if(value == 1) {
                                 int result = await PlayerControls.playSong(s.values.toList()[0][0],
                        s.values.toList()[0][0].filePath, widget.audioPlayer);
                    if (result == 1) {
                      songDataNoListen.listType = s.values.toList()[0];
                  songDataNoListen.listLength = s.values.toList()[0].length;
                      songDataNoListen.currentSongIndex = index;
                      songDataNoListen.currentSong = s;
                      
                      songDataNoListen.audioPlayerState = widget.audioPlayer.state;
                    }
                                } else {
                                  songDataNoListen.deletePlayList(s);
                                }
                              },
                              icon: Icon(Icons.list, color: Colors.lightBlueAccent,),
                              itemBuilder: (context) => [
                                PopupMenuItem( 
                                  value: 1,
                                  child: ListTile(
                                    title: Text('Play'),
                                    leading: Icon(Icons.play_circle_filled),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    title: Text('Delete'),
                                    leading: Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),   
                  title: Text(s.keys.toList()[0]),
                  subtitle: s.values.toList()[0].length < 1 || s.values.toList()[0].length > 1 ? Text(
                    "${s.values.toList()[0].length} songs",
                    style: Theme.of(context).textTheme.caption,
                  ) : Text(
                    "${s.values.toList()[0].length} song       ",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
        context,
        PlaylistSongs.id,
        arguments: Playlist(
          audioPlayer: widget.audioPlayer,
         
          playlistItem: s,
        ),
      );
                  },
                ),
                Divider(),
              ],
            );
            
          },
        ),),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: ()  {
         _addPlaylistDialog(context);
        
        },),
      ),
    );
  }   
}