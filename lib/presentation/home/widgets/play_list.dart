import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'music_player_screen.dart';

class PlayList extends StatelessWidget {
  final Function(int) onSongSelected;

  const PlayList({super.key, required this.onSongSelected});

  final List<Map<String, String>> songs = const [
    {
      "title": "Nuansa Bening",
      "url": "https://finolut.github.io/musik/song/nuansa-bening.mp3",
      "cover": "https://finolut.github.io/musik/cover/nuansa-bening.jpg",
    },
    {
      "title": "DJ Kuhanya Bisa",
      "url": "https://raw.githubusercontent.com/Finolut/musik/main/song/djkuhanya-bisa.mp3",
      "cover": "https://raw.githubusercontent.com/Finolut/musik/main/cover/dj-kuhanya-bisa.jpg",
    },
    {
      "title": "Cigarettes After Sex",
      "url": "https://raw.githubusercontent.com/Finolut/musik/main/song/Cigarettes After Sex (Slowed & Reverb).mp3",
      "cover": "https://raw.githubusercontent.com/Finolut/musik/main/cover/Cigarettes_After_Sex.png",
    },
    {
      "title": "DJ aku bingung sendiri",
      "url": "https://raw.githubusercontent.com/Finolut/musik/main/song/aku bingung sendiri.mp3",
      "cover": "https://raw.githubusercontent.com/Finolut/musik/main/cover/dj aku bingung sendiri.jpg",
    },
  ];

  void _openMusicPlayer(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerScreen(
          song: songs[index],
          isPlaying: false, // Status awal dikelola oleh HomePage
          onPlayPause: () => onSongSelected(index),
          onSkipNext: () {},
          onSkipPrevious: () {},
          audioPlayer: AudioPlayer(), // AudioPlayer dikelola di HomePage
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> song = entry.value;

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: GestureDetector(
              onTap: () => _openMusicPlayer(context, index),
              child: Image.network(
                song["cover"]!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(song["title"]!),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle),
              onPressed: () => onSongSelected(index),
            ),
          ),
        );
      }).toList(),
    );
  }
}