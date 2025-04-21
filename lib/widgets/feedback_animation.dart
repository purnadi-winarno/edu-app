import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedbackAnimation extends StatelessWidget {
  final bool isCorrect;
  final double size;

  const FeedbackAnimation({
    super.key,
    required this.isCorrect,
    this.size = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: isCorrect ? _buildSuccessAnimation() : _buildFailureAnimation(),
    );
  }

  Widget _buildSuccessAnimation() {
    return Icon(Icons.check_circle, size: size, color: Colors.green);
  }

  Widget _buildFailureAnimation() {
    return Icon(Icons.cancel, size: size, color: Colors.red);
  }
}
