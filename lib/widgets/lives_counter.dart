import 'package:flutter/material.dart';

class LivesCounter extends StatelessWidget {
  final int lives;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const LivesCounter({
    super.key,
    required this.lives,
    this.size = 24.0,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = index < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.favorite,
            color: isActive ? activeColor : inactiveColor.withOpacity(0.5),
            size: size,
          ),
        );
      }),
    );
  }
}
