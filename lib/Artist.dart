class Artist {
  final String url;
  final String name;
  final String mbid;

  Artist({
    required this.url,
    required this.name,
    required this.mbid,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(url: json['url'], name: json['name'], mbid: json['mbid']);
  }
}
