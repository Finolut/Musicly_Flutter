import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Map<String, String> song;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSkipNext;
  final VoidCallback onSkipPrevious;
  final AudioPlayer audioPlayer;

  const MusicPlayerScreen({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSkipNext,
    required this.onSkipPrevious,
    required this.audioPlayer,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;

    // Listener untuk posisi audio
    widget.audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    // Listener untuk durasi audio
    widget.audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    // Listener untuk status pemutaran
    widget.audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Cek apakah audio sudah dimulai, jika belum, mulai pemutaran
    if (_isPlaying && widget.audioPlayer.state != PlayerState.playing) {
      widget.audioPlayer.play(UrlSource(widget.song["url"]!));
    }
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await widget.audioPlayer.pause();
      } else {
        await widget.audioPlayer.play(UrlSource(widget.song["url"]!));
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
      widget.onPlayPause(); // Panggil callback untuk sinkronisasi dengan PlayList
    } catch (e) {
      print("Error toggling play/pause: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memutar lagu: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.song["cover"]!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 300, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.song["title"]!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Unknown Artist",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),

            // Progress Bar
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
              value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
              activeColor: Colors.green,
              inactiveColor: Colors.white38,
              onChanged: (value) {
                widget.audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),

            // Waktu Durasi Lagu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    _formatDuration(_position),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    _formatDuration(_duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Musik
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: widget.onSkipPrevious,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 60,
                  ),
                  onPressed: _togglePlayPause, // Gunakan fungsi lokal
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: widget.onSkipNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}