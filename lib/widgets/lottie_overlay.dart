import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieOverlay extends StatefulWidget {
  final bool isPlaying;
  final Widget child;
  final String animationPath;

  const LottieOverlay({
    super.key,
    required this.isPlaying,
    required this.child,
    required this.animationPath,
  });

  @override
  State<LottieOverlay> createState() => _LottieOverlayState();
}

class _LottieOverlayState extends State<LottieOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void didUpdateWidget(LottieOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.forward();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isPlaying)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: Center(
                child: Lottie.asset(
                  widget.animationPath,
                  controller: _animationController,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  animate: true,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
