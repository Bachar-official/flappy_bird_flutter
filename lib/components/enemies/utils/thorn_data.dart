class ThornData {
  final double time;
  final double height;
  final bool bottom;

  const ThornData(
      {required this.time, required this.height, required this.bottom});

  factory ThornData.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'time': double time,
          'height': double height,
          'bottom': bool bottom
        }) {
      return ThornData(time: time, height: height, bottom: bottom);
    } else {
      throw const FormatException('Invalid JSON format for \'thorns\' field');
    }
  }
}
