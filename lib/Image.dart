class Image {
  final String size;
  final String text;

  Image({
    required this.size,
    required this.text,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      size: json['size'] as String,
      text: json['#text'] as String,
    );
  }
}
