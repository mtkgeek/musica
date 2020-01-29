// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongDataAdapter extends TypeAdapter<SongData> {
  @override
  SongData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongData(
      (fields[0] as List)?.cast<dynamic>(),
      (fields[3] as List)?.cast<AlbumInfo>(),
    )
      .._favoriteSongs = (fields[1] as List)?.cast<dynamic>()
      .._playList = (fields[2] as List)?.cast<dynamic>()
      .._currentSong = fields[4] as SongInfo;
  }

  @override
  void write(BinaryWriter writer, SongData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._songs)
      ..writeByte(1)
      ..write(obj._favoriteSongs)
      ..writeByte(2)
      ..write(obj._playList)
      ..writeByte(3)
      ..write(obj._albums)
      ..writeByte(4)
      ..write(obj._currentSong);
  }
}
