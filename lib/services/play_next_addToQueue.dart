import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

class QueueService extends StatefulWidget {
  final Map<String, dynamic> songData;

  const QueueService({super.key, required this.songData});

  @override
  State<QueueService> createState() => _QueueServiceState();
}

class _QueueServiceState extends State<QueueService> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'item1':
            void play_next() async {
              final Audio nextSong = Audio.network(
                widget.songData['downloadUrl'][2]['link'],
                metas: Metas(
                  title: widget.songData['name'],
                  artist: widget.songData['primaryArtists'],
                  album: widget.songData['album']['name'],
                  image:
                      MetasImage.network(widget.songData['image'][2]['link']),
                ),
              );

              final playerName = AssetsAudioPlayer.allPlayers();
              // print(playerName);
              if (playerName.isNotEmpty) {
                // print('in iffffff');
                String f = playerName.keys.toList()[0];
                final audioplayer = AssetsAudioPlayer.withId(f);
                int index = audioplayer.readingPlaylist!.currentIndex;
                audioplayer.playlist!.insert(index + 1, nextSong);
              } else {
                // print("in else");
                final selectedSongDataProvider =
                    Provider.of<SelectedSongDataProvider>(context,
                        listen: false);
                selectedSongDataProvider
                    .updateSelectedSongData(widget.songData);
              }
            }
            play_next();
            break;
          case 'item2':
            void add_to_queue() async {
              final Audio lastSong = Audio.network(
                widget.songData['downloadUrl'][2]['link'],
                metas: Metas(
                  title: widget.songData['name'],
                  artist: widget.songData['primaryArtists'],
                  album: widget.songData['album']['name'],
                  image:
                      MetasImage.network(widget.songData['image'][2]['link']),
                ),
              );
              final playerName = AssetsAudioPlayer.allPlayers();
              if (playerName.isNotEmpty) {
                String f = playerName.keys.toList()[0];
                final audioplayer = AssetsAudioPlayer.withId(f);
                int index = audioplayer.playlist!.audios.length;
                audioplayer.playlist!.insert(index + 1, lastSong);
              }
              else {
                final selectedSongDataProvider =
                    Provider.of<SelectedSongDataProvider>(context,
                        listen: false);
                selectedSongDataProvider
                    .updateSelectedSongData(widget.songData);
              }
            }
            add_to_queue();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'item1',
          child: Text('Play Next'),
        ),
        const PopupMenuItem(
          value: 'item2',
          child: Text('Add to Queue'),
        ),
      ],
      onCanceled: () {
        // When the popup is canceled, unfocus any active text fields
        FocusScope.of(context).unfocus();
      },
    );
  }
}
