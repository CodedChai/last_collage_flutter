import 'Artist.dart';
import 'Image.dart';

class Album {
  final Artist artist;
  final List<Image> images;
  final String mbid;
  final String url;
  final String playcount;
  final String name;

  Album({
    required this.artist,
    required this.images,
    required this.mbid,
    required this.url,
    required this.playcount,
    required this.name,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    List<Image> images = [];
    json['image'].forEach((v) {
      images.add(Image.fromJson(v));
    });

    return Album(
      artist: Artist.fromJson(json['artist']),
      images: images,
      mbid: json['mbid'],
      url: json['url'],
      playcount: json['playcount'],
      name: json['name'],
    );
  }
}
