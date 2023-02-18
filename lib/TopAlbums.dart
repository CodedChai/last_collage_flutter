import 'Album.dart';

class TopAlbums {
  final List<Album> albums;

  TopAlbums({
    required this.albums,
  });

  factory TopAlbums.fromJson(Map<String, dynamic> json) {
    List<Album> albums = [];
    json['topalbums']['album'].forEach((v) {
      albums.add(Album.fromJson(v));
    });

    return TopAlbums(
      albums: albums,
    );
  }
}
