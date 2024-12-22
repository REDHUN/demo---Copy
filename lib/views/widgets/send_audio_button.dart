import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/audio_view_model.dart';

class SendAudioButton extends StatelessWidget {
  final Duration minTime;

  const SendAudioButton({
    super.key,
    this.minTime = const Duration(minutes: 2),
  });

  Future<void> _showMinTimeDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Icon(
          Icons.timer_outlined,
          color: colorScheme.error,
          size: 32,
        ),
        title: Text(
          'Recording Too Short',
          style: TextStyle(
            color: colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Required minimum audio length is ${minTime.inSeconds}s',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Please record a longer response',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isRecording) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              final recordingDuration = viewModel.duration;
              if (recordingDuration < minTime) {
                _showMinTimeDialog(context);
                return;
              }
              // TODO: Implement sharing functionality
            },
            icon: const Icon(Icons.send),
            label: const Text('Share Audio'),
          ),
        );
      },
    );
  }
}
