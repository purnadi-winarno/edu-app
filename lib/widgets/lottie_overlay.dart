import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'animated_praise.dart';

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
  Key _animatedPraiseKey = UniqueKey();

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
      setState(() {
        _animatedPraiseKey = UniqueKey();
      });
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
      fit: StackFit.expand,
      children: [
        widget.child,
        if (widget.isPlaying)
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.black87,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Lottie.asset(
                        widget.animationPath,
                        width: 200,
                        height: 200,
                        repeat: true,
                      ),
                      AnimatedPraise(key: _animatedPraiseKey),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
