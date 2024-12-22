import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/audio_view_model.dart';

class SendAudioButton extends StatelessWidget {
  const SendAudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioViewModel>(
      builder: (context, viewModel, child) {
        final audioModel = viewModel.audioModel;

        if (audioModel.path == null || audioModel.isRecording) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  final base64Audio = await viewModel.getBase64Audio();
                  if (base64Audio != null && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: AlertDialog(
                            title: const Text('Audio Base64'),
                            content: SingleChildScrollView(
                              child: SelectableText(
                                base64Audio,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Share Audio',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
