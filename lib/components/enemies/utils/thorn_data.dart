class ThornData {
  final double time;
  final double duration;
  final String label;
  final int y;

  const ThornData(
      {required this.time,
      required this.duration,
      required this.label,
      required this.y});

  factory ThornData.fromJson(Map<String, dynamic> json) {
    if (json['time'] == null ||
        json['duration'] == null ||
        json['label'] == null ||
        json['y'] == null) {
      throw const FormatException('Missing fields in thorn data');
    }
    return ThornData(
      time: json['time'],
      duration: json['duration'],
      label: json['label'],
      y: json['y'],
    );
  }
}
