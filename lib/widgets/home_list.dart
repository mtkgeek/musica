import 'dart:io';


import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import '../models/songs.dart';


class HomeList extends StatefulWidget {
  
  
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  var songData;
  
  var songDataNoListen;

  

  
  @override
  Widget build(BuildContext context) {
    songData = Provider.of<SongData>(context);

    songDataNoListen = Provider.of<SongData>(context, listen: false);
    return Scrollbar(
      child: ListView.builder(
      shrinkWrap: true, 
        itemCount: songDataNoListen.albumsLength,
        itemBuilder: (context, int index) {
          final s = songDataNoListen.albums[index];
         

          return 
Card(
  
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  child:   ListTile(
    isThreeLine: true,
  
            contentPadding:
  
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  
            leading: Container(
  
              padding: EdgeInsets.only(right: 12.0),
  
              decoration: BoxDecoration(
  
                  border: Border(
  
                      right: BorderSide(width: 1.0, color: Colors.black54))),
  
              child: CircleAvatar(
  
                                backgroundColor: Theme.of(context).primaryColor,
  
                                backgroundImage: s.albumArt !=
  
                                        null
  
                                    ? FileImage(
  
                                        File(s.albumArt))
  
                                    : AssetImage(
  
                                        'assets/images/placeholder.jpg',
  
                                      ),
  
                                radius: 30,
  
                              ),
  
            ),
  
            title: Text(
  
              'Album: ${s.title}',
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.black54),
  
            ),
  
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
  
  
  
            subtitle: Row(
  
              children: <Widget>[
  
                Expanded(
  
                    flex: 1,
  
                    child: Container(
  
                      // tag: 'hero',
  
                      child: Text(
  
              '\nBy ${s.artist}\n\nSongs: ${s.numberOfSongs}',
  
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black54),
  
            ),
  
                    ),  
  
                ), 
  
              ],
  
            ),
  
            
  
            onTap: () {
  
              
  
            },
  
          ),
);
        },
      ),
    );
  }
}




