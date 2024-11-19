class HourData {
  final double time;
  final int score;
  final double pos;

  const HourData({required this.score, required this.pos, required this.time});

  factory HourData.fromJson(Map<String, dynamic> json) {
    if (json
        case {'score': int score, 'pos': double pos, 'time': double time}) {
      return HourData(
        score: score,
        pos: pos,
        time: time,
      );
    } else {
      throw const FormatException('Invalid JSON format for \'hours\' field');
    }
  }
}
