import 'dart:math';
import 'dart:typed_data';

double calculateVolume(List<int> data) {
  final buffer =
      Int16List.fromList(data); // Преобразуем данные в 16-битные целые
  double sum = 0.0;

  // Суммируем квадраты значений для RMS
  for (var sample in buffer) {
    sum += sample * sample;
  }

  // Рассчитываем среднеквадратичное значение (RMS)
  double rms = sqrt(sum / buffer.length);
  return rms;
}

double calculateVolumeLn(List<int> data) {
  final buffer = Int16List.fromList(data);
  double sum = 0.0;

  for (var sample in buffer) {
    sum += sample * sample;
  }

  double rms = sqrt(sum / buffer.length);

  // Логарифмическое преобразование для громкости в децибелах
  double volumeDb = 20 * log(rms);

  // Ограничиваем результат, чтобы избежать отрицательных значений
  volumeDb = volumeDb.isNaN || volumeDb < 0 ? 0 : volumeDb;

  return volumeDb;
}
