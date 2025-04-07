import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/home/widgets/news_songs.dart';
import 'package:spotify/presentation/home/widgets/play_list.dart';
import 'package:spotify/presentation/home/widgets/now_playing_bar.dart';
import 'package:spotify/presentation/profile/pages/profile.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<String, String>? _currentSong;
  bool _isPlaying = false;
  int _currentIndex = 0; // Untuk BottomNavigationBar
  int _currentSongIndex = 0; // Untuk indeks lagu

  final List<Map<String, String>> songs = [
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentSong = songs[_currentSongIndex];
  }

  void _playSong(int index) async {
    try {
      if (_isPlaying && _currentSongIndex == index) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(songs[index]["url"]!));
      }
      setState(() {
        _currentSongIndex = index;
        _currentSong = songs[index];
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  void _skipNext() {
    int nextIndex = (_currentSongIndex + 1) % songs.length;
    _playSong(nextIndex);
  }

  void _skipPrevious() {
    int prevIndex = (_currentSongIndex - 1 + songs.length) % songs.length;
    _playSong(prevIndex);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Widget untuk setiap tab
  Widget _buildHomeContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _homeTopCard(),
                _tabs(),
                SizedBox(
                  height: 260,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      const NewsSongs(),
                      Container(),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
                PlayList(
                  onSongSelected: (index) => _playSong(index),
                ),
              ],
            ),
          ),
        ),
        if (_currentSong != null)
          NowPlayingBar(
            currentSong: _currentSong!,
            isPlaying: _isPlaying,
            onPlayPause: () => _playSong(_currentSongIndex),
            onSkipNext: _skipNext,
            onSkipPrevious: _skipPrevious,
            audioPlayer: _audioPlayer,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const ProfilePage(),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: Image.asset(AppImages.logo, height: 120, width: 120),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(), // Home
          Container(color: Colors.grey[200], child: Center(child: Text('Samples'))), // Samples
          Container(color: Colors.grey[200], child: Center(child: Text('Explore'))), // Explore
          Container(color: Colors.grey[200], child: Center(child: Text('Library'))), // Library
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Samples',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(AppImages.top2),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      tabs: const [
        Text('News', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Text('Rekomendasi', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Text('Artists', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Text('Podcasts', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      ],
    );
  }
}