class AudioModel {
  final String? path;
  final Duration position;
  final Duration duration;
  final Duration recordDuration;
  final bool isPlaying;
  final bool isRecording;
  final bool hasPermission;

  AudioModel({
    this.path,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.recordDuration = Duration.zero,
    this.isPlaying = false,
    this.isRecording = false,
    this.hasPermission = false,
  });

  AudioModel copyWith({
    String? path,
    Duration? position,
    Duration? duration,
    Duration? recordDuration,
    bool? isPlaying,
    bool? isRecording,
    bool? hasPermission,
  }) {
    return AudioModel(
      path: path ?? this.path,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      recordDuration: recordDuration ?? this.recordDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isRecording: isRecording ?? this.isRecording,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}
