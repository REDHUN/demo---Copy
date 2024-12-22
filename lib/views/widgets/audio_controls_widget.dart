import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/audio_view_model.dart';
import 'waveform_animation.dart';

class AudioControlsWidget extends StatelessWidget {
  const AudioControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioViewModel>(
      builder: (context, viewModel, child) {
        final audioModel = viewModel.audioModel;

        // if (!audioModel.hasPermission) {
        //   return Column(
        //     children: [
        //       ElevatedButton.icon(
        //         onPressed: viewModel.requestPermissions,
        //         icon: const Icon(Icons.mic),
        //         label: const Text('Grant Microphone Access'),
        //         style: ElevatedButton.styleFrom(
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(30),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 16),
        //       const Text(
        //         'Microphone permission is required',
        //         style: TextStyle(color: Colors.red),
        //       ),
        //     ],
        //   );
        // }

        return Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: audioModel.isRecording
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WaveformAnimation(),
                        const SizedBox(height: 8),
                        Text(
                          viewModel.formatDuration(audioModel.recordDuration),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    )
                  : const Icon(Icons.mic, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: audioModel.isRecording
                  ? viewModel.stopRecording
                  : viewModel.startRecording,
              icon: Icon(audioModel.isRecording ? Icons.stop : Icons.mic),
              label: Text(audioModel.isRecording
                  ? 'Stop Recording'
                  : 'Start Recording'),
              backgroundColor: audioModel.isRecording
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      },
    );
  }
}
