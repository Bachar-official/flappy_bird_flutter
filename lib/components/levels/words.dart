class Words {
  final double show;
  final double start;
  final double end;
  final String text;
  final int str;

  const Words(
      {required this.start,
      required this.end,
      required this.text,
      required this.show,
      required this.str});

  factory Words.fromJson(Map<String, dynamic> json) {
    if (json['text'] == null ||
        json['start'] == null ||
        json['end'] == null ||
        json['show'] == null ||
        json['str'] == null) {
      throw const FormatException('Missing JSON fields');
    }
    // if (json['text']! is String ||
    //     json['start']! is double ||
    //     json['end']! is double ||
    //     json['show']! is double ||
    //     json['str']! is int ||
    //     json['str'] < 0 ||
    //     json['str'] > 1) {
    //   throw const FormatException('Invalid JSON format');
    // }
    return Words(
      start: json['start'] as double,
      end: json['end'] as double,
      text: json['text'] as String,
      show: json['show'] as double,
      str: json['str'] as int,
    );
  }
}
