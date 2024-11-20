class Song {
  final String author;
  final String song;
  final String music;
  final String fileName;

  const Song(
      {required this.author,
      required this.song,
      required this.music,
      required this.fileName});

  factory Song.fromFile(String fileName, Map<String, dynamic> json) {
    return Song(
      fileName: fileName,
      author: json['author'],
      song: json['song'],
      music: json['music'],
    );
  }
}
