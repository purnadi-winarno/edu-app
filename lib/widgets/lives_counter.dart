import 'package:flutter/material.dart';

class LivesCounter extends StatefulWidget {
  final int lives;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool isAnimating;

  const LivesCounter({
    super.key,
    required this.lives,
    this.size = 24.0,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
    this.isAnimating = false,
  });

  @override
  State<LivesCounter> createState() => _LivesCounterState();
}

class _LivesCounterState extends State<LivesCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create shake animation
    _shakeAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.05, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );

    // Listen for animation status to reverse when completed
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });

    // Start animation if required
    if (widget.isAnimating) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LivesCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start animation if lives decreased
    if (widget.lives < oldWidget.lives) {
      _animationController.forward();
    }

    // Also start animation if isAnimating changed
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final isActive = index < widget.lives;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.favorite,
              color:
                  isActive
                      ? widget.activeColor
                      : widget.inactiveColor.withOpacity(0.5),
              size: widget.size,
            ),
          );
        }),
      ),
    );
  }
}
