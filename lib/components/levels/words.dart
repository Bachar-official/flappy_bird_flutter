class Words {
  final double start;
  final double end;
  final String text;

  const Words({required this.start, required this.end, required this.text});

  factory Words.fromJson(Map<String, dynamic> json) {
    if (json['text'] == null || json['start'] == null || json['end'] == null) {
      throw const FormatException('Invalid JSON format');
    }
    return Words(
      start: json['start'] as double,
      end: json['end'] as double,
      text: json['text'] as String,
    );
  }
}
