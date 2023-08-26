import 'package:SoundDash/services/play_next_addToQueue.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayAlbumCard extends StatelessWidget {
  final dynamic songData;

  const PlayAlbumCard({required this.songData});

  @override
  Widget build(BuildContext context) {
    final songName = songData['name'] as String? ?? '';
    final artistName = songData['primaryArtists'] as String? ?? '';
    final imageLink = songData['image'][2]['link'] as String? ?? '';
    // print(imageLink);
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        selectedSongDataProvider.updateSelectedSongData(songData);
      },
      child: Container(
        // height: 100,
        // color: Color.fromARGB(255, 26, 4, 28),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Card(
            color: Color.fromARGB(255, 251, 246, 251).withOpacity(0),
            child: ListTile(
              leading: Image.network(
                imageLink,
                width: 100,
                height: 100,
              ),
              title: Text(
                songName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: QueueService(songData: songData),
            ),
          ),
        ),
      ),
    );
  }
}
