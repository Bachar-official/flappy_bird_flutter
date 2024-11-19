import 'dart:async';

import 'package:flappy_bird/components/levels/level.dart';
import 'package:flappy_bird/components/song_button.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

class MainScreen extends StatefulWidget {
  final FlappyBirdGame game;
  const MainScreen({super.key, required this.game});

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
  bool isRecording = false;
  Color sliderColor = Colors.red;

  @override
  void initState() {
    super.initState();
    widget.game.pauseEngine();
    nameC.addListener(() => setState(() {}));
    setStream();
  }

  void setStream() async {
    await waveC.startRecording();
    isRecording = true;
    await for (var a in waveC.amplitudeStream) {
      if (a.current <= -1) {
        controller.sink.add(a.current);
      }

      if (mounted) {
        setSliderColor(a.current, threshold);
      }
    }
  }

  void setThreshold(double value) {
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

  void startGame() async {
    widget.game.setAudioStream(controller.stream);
    widget.game.setThreshold(threshold);
    widget.game.setPlayerName(nameC.value.text);
    widget.game.overlays.remove('mainMenu');
    widget.game.resumeEngine();

    try {
      var lvl = await loadLevel('level1.json');
      widget.game.setLevel(lvl);
    } catch (e) {
      widget.game.overlays.add('mainMenu');
      widget.game.pauseEngine();
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

  List<Widget> songs = [
    SongButton(
      group: 'На-на',
      song: 'Фаина',
      onTap: () {},
    ),
    SongButton(
      group: 'Технология',
      song: 'Нажми на кнопку',
      onTap: () {},
    ),
    SongButton(
      group: 'Кай Метов',
      song: 'Position №1',
      onTap: () {},
    ),
    SongButton(
      group: 'Филипп Киркоров',
      song: 'Зайка моя',
      onTap: () {},
    ),
    SongButton(
      group: 'Надежда Кадышева',
      song: 'А я вовсе не колдунья',
      onTap: () {},
    ),
  ];

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
              ElevatedButton(
                onPressed: nameC.value.text.isEmpty ? null : startGame,
                child: const Text('Начать игру'),
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
                  itemBuilder: (context, index) => songs[index],
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
            ],
          ),
        ),
      ),
    );
  }
}
