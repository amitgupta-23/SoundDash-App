import 'package:SoundDash/audio_navBar/bottom_song_player.dart';
import 'package:SoundDash/audio_navBar/playlist_player.dart';
import 'package:SoundDash/pages/home.dart';
import 'package:SoundDash/pages/join.dart';
import 'package:SoundDash/pages/library.dart';
import 'package:SoundDash/pages/search.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context);
    final selectedSongData = selectedSongDataProvider.selectedSongData;

    Widget playerWidget;

    if (selectedSongData is Map<String, dynamic>) {
      playerWidget = BottomSongPlayer(
        songData: selectedSongData,
        key: Key(selectedSongData.toString()),
      );
    } else if (selectedSongData is List<dynamic> &&
        selectedSongData.isNotEmpty) {
      playerWidget = PlaylistPlayer(
        playlistData: selectedSongData,
        key: Key(selectedSongData.toString()),
      );
    } else {
      playerWidget = const SizedBox();
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            renderView(
              0,
              const Home(),
            ),
            renderView(
              1,
              Search(),
            ),
            renderView(
              2,
              const Join(),
            ),
            renderView(
              3,
              const Library(),
            ),
            if (selectedSongData != null) playerWidget,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Join",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            label: "Library",
          ),
        ],
      ),
    );
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: _selectedTab != tabIndex,
      child: Opacity(
        opacity: _selectedTab == tabIndex ? 1 : 0,
        child: view,
      ),
    );
  }
}
