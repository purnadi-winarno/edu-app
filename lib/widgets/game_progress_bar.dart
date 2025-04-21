import 'package:flutter/material.dart';

class GameProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double height;
  final double borderRadius;
  final double width;

  const GameProgressBar({
    super.key,
    required this.progress,
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.height = 15.0,
    this.borderRadius = 8.0,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
