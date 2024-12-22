import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/audio_view_model.dart';
import 'timer_display.dart';
import 'waveform_animation.dart';

class AudioControlsWidget extends StatelessWidget {
  final Duration minTime;

  const AudioControlsWidget({
    super.key,
    this.minTime = const Duration(minutes: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: viewModel.isRecording
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WaveformAnimation(),
                        const SizedBox(height: 8),
                        TimerDisplay(
                          duration: viewModel.recordDuration,
                          isRecording: viewModel.isRecording,
                        ),
                      ],
                    )
                  : const Icon(Icons.mic, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: viewModel.isRecording
                  ? viewModel.stopRecording
                  : viewModel.startRecording,
              icon: Icon(viewModel.isRecording ? Icons.stop : Icons.mic),
              label: Text(
                  viewModel.isRecording ? 'Stop Recording' : 'Start Recording'),
              backgroundColor: viewModel.isRecording
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      },
    );
  }
}
