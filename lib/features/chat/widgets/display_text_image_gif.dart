import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Priva/common/enums/message_enum.dart';
import 'package:Priva/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  late final AudioPlayer _audioPlayer;
  late bool isPlaying;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    isPlaying = false;
    isLoading = false;

    // Listen for playback state and position changes
    _audioPlayer.playbackEventStream.listen((event) {
      final processingState = event.processingState;
      if (processingState == ProcessingState.ready ||
          processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = _audioPlayer.playing;
          isLoading = false; // Audio is ready or finished
        });
      } else if (processingState == ProcessingState.loading) {
        setState(() {
          isLoading = true; // Show loading indicator
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? Text(
            widget.message,
            style: const TextStyle(fontSize: 16),
          )
        : widget.type == MessageEnum.audio
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) const CircularProgressIndicator(),
                  StreamBuilder<Duration?>(
                    stream: _audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return Slider(
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        value: _audioPlayer.position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        },
                      );
                    },
                  ),
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 100),
                    onPressed: () async {
                      try {
                        if (isPlaying) {
                          await _audioPlayer.pause();
                        } else {
                          await _audioPlayer.setUrl(widget.message);
                          await _audioPlayer.play();
                        }
                      } catch (e) {
                        print('Error playing audio: $e');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to play audio'),
                        ));
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                    ),
                  ),
                ],
              )
            : widget.type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: widget.message)
                : widget.type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: widget.message,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        child: CachedNetworkImage(
                          imageUrl: widget.message,
                          fit: BoxFit.cover,
                        ),
                      );
  }
}
