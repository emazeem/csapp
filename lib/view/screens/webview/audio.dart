import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/widgets/page_manager.dart';

class AudioScreen extends StatefulWidget {
  final String audioUrl;

  const AudioScreen({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late final PageManager _pageManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageManager = PageManager(url: widget.audioUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _pageManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Audio Player')),
      body: Center(
        child: Container(
          color: Colors.black,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    width: 60,
                    height: 60,
                    child: ValueListenableBuilder<ButtonState>(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (_, value, __) {
                        switch (value) {
                          case ButtonState.loading:
                            return Container(
                                margin: const EdgeInsets.all(10),
                                width: 32.0,
                                height: 32.0,
                                child: Utils.LoadingIndictorWidtet());
                          case ButtonState.paused:
                            return IconButton(
                              icon: const Icon(Icons.play_arrow),
                              iconSize: 32.0,
                              onPressed: _pageManager.play,
                            );
                          case ButtonState.playing:
                            return IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 32.0,
                              onPressed: _pageManager.pause,
                            );
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: ValueListenableBuilder<ProgressBarState>(
                        valueListenable: _pageManager.progressNotifier,
                        builder: (_, value, __) {
                          return Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 10, right: 10),
                            child: ProgressBar(
                              progressBarColor: Constants.np_yellow,
                              bufferedBarColor: Colors.black12,
                              baseBarColor: Colors.transparent,
                              progress: value.current,
                              buffered: value.buffered,
                              total: value.total,
                              barHeight: 3,
                              thumbColor: Constants.np_yellow,
                              onSeek: _pageManager.seek,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
