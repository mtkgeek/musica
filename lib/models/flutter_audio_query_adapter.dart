// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:hive/hive.dart';


// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongInfoAdapter extends TypeAdapter<SongInfo> {
  @override
  SongInfo read(BinaryReader reader) {
    
     var fields = <dynamic, dynamic>{
       'album_id' : reader.read(),
       'artist_id' : reader.read(),
      'artist' : reader.read(),
      'album' : reader.read(),
      'title' : reader.read(),
      '_display_name' : reader.read(),
      'composer' : reader.read(),
      'year' : reader.read(),
      'track' : reader.read(),
      'duration' : reader.read(),
      'bookmark' : reader.read(),
      '_data' : reader.read(),
      '_size' : reader.read(),
      'album_artwork' : reader.read(),
      
    };
    return SongInfo(fields);
      
  }

  @override
  void write(BinaryWriter writer, SongInfo obj) {
    writer.write(obj.albumId);
    writer.write(obj.artistId);
    writer.write(obj.artist);
    writer.write(obj.album);
    writer.write(obj.title);
    writer.write(obj.displayName);
    writer.write(obj.composer);
    writer.write(obj.year);
    writer.write(obj.track);
    writer.write(obj.duration);
    writer.write(obj.bookmark);
    writer.write(obj.filePath);
    writer.write(obj.fileSize);
    writer.write(obj.albumArtwork);
  }
}
