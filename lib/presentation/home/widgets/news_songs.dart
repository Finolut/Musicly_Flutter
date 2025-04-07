import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NewsSongs extends StatefulWidget {
  const NewsSongs({super.key});

  @override
  State<NewsSongs> createState() => _NewsSongsState();
}

class _NewsSongsState extends State<NewsSongs> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String songUrl =
      "https://finolut.github.io/musik/song/nuansa-bening.mp3";

  bool isPlaying = false;

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(songUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          "https://finolut.github.io/musik/cover/nuansa-bening.jpg",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: const Text("Nuansa Bening"),
        subtitle: const Text("By Unknown Artist"),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
          onPressed: _togglePlayPause,
        ),
      ),
    );
  }
}
