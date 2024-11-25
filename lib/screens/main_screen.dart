import 'dart:async';

import 'package:flappy_bird/components/levels/level.dart';
import 'package:flappy_bird/components/song_button.dart';
import 'package:flappy_bird/entity/song.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/utils/get_json_files.dart';
import 'package:flutter/material.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

class MainScreen extends StatefulWidget {
  final FlappyBirdGame game;
  double threshold;
  final void Function(double) setThreshold;
  MainScreen(
      {super.key,
      required this.game,
      required this.threshold,
      required this.setThreshold});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double triggerCoefficient = 1;
  final TextEditingController nameC = TextEditingController(text: '');
  StreamController<double> controller = StreamController.broadcast();
  bool triggered = false;
  final waveC =
      WaveformRecorderController(interval: const Duration(milliseconds: 2));
  double threshold = -20;
  double amp = -60;
  bool isRecording = false;
  Color sliderColor = Colors.red;
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    threshold = widget.threshold;
    widget.game.pauseEngine();
    nameC.addListener(() => setState(() {}));
    setStream();
    getSongs().then((v) {
      songs = v;
      setState(() {});
    });
  }

  void setStream() async {
    await waveC.startRecording();
    isRecording = true;
    await for (var a in waveC.amplitudeStream) {
      controller.sink.add(a.current);

      if (mounted) {
        setSliderColor(a.current, threshold);
        setAmp(a.current);
      }
    }
  }

  void setAmp(double value) {
    amp = value;
    setState(() {});
  }

  void setThreshold(double value) {
    widget.setThreshold(value);
    threshold = value;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setSliderColor(double value, double threshold) {
    if (context.mounted) {
      if (value > threshold) {
        sliderColor = Colors.green;
      } else {
        sliderColor = Colors.red;
      }
      setState(() {});
    }
  }

  void startGame(String fileName) async {
    widget.game.setAudioStream(controller.stream);
    widget.game.setThreshold(threshold);
    widget.game.setPlayerName(nameC.value.text);
    widget.game.overlays.remove('mainMenu');
    widget.game.resumeEngine();

    try {
      var lvl = await loadLevel('levels/$fileName');
      widget.game.setLevel(lvl);
      await widget.game.playBackgroundMusic();
    } catch (e) {
      widget.game.overlays.add('mainMenu');
      widget.game.pauseEngine();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Имя игрока'),
                ),
                controller: nameC,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2 / 1,
                  ),
                  itemCount: songs.length,
                  itemBuilder: (context, index) => SongButton(
                      group: songs[index].author,
                      song: songs[index].song,
                      onTap: nameC.text.isEmpty
                          ? null
                          : () {
                              startGame(songs[index].fileName);
                            }),
                ),
              ),
              Slider(
                thumbColor: sliderColor,
                activeColor: sliderColor,
                min: -50.0,
                max: 0.0,
                value: threshold,
                onChanged: setThreshold,
              ),
              const Text('Порог срабатывания'),
              LinearProgressIndicator(
                minHeight: 10,
                value: (amp + 60) / 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
