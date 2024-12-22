import 'package:flutter/material.dart';

class WaveformAnimation extends StatefulWidget {
  const WaveformAnimation({super.key});

  @override
  State<WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 12.0 + (12.0 * _controller.value * (index % 3 + 1)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
