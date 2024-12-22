import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/audio_view_model.dart';
import '../../views/widgets/send_audio_button.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.path == null || viewModel.isRecording) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Card(
              margin: const EdgeInsets.only(top: 32),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    IconButton.filled(
                      onPressed: viewModel.playRecording,
                      icon: Icon(
                          viewModel.isPlaying ? Icons.stop : Icons.play_arrow),
                      iconSize: 32,
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 8),
                      ),
                      child: Slider(
                        value: viewModel.position.inSeconds.toDouble(),
                        min: 0,
                        max: viewModel.duration.inSeconds.toDouble(),
                        onChanged: (value) async {
                          await viewModel
                              .seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            viewModel.formatDuration(viewModel.position),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            viewModel.formatDuration(viewModel.duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SendAudioButton(),
          ],
        );
      },
    );
  }
}
