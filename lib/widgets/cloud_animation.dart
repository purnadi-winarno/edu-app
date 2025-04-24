import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StaticCloudPosition {
  above, // Static cloud appears above moving clouds
  inline, // Static cloud appears in the same line as moving clouds
  below, // Static cloud appears below moving clouds
  none, // No static cloud
}

class CloudAnimation extends StatefulWidget {
  final int numberOfMovingClouds;
  final bool showStaticCloud;
  final StaticCloudPosition staticCloudPosition;
  final double staticCloudScale;
  final double movingCloudBaseScale;
  final double yPositionStart;
  final double yPositionEnd;

  const CloudAnimation({
    super.key,
    this.numberOfMovingClouds = 5,
    this.showStaticCloud = true,
    this.staticCloudPosition = StaticCloudPosition.above,
    this.staticCloudScale = 1.0,
    this.movingCloudBaseScale = 0.5,
    this.yPositionStart = 0.1,
    this.yPositionEnd = 0.4,
  });

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation>
    with TickerProviderStateMixin {
  final List<CloudData> _clouds = [];
  final Random _random = Random();
  late final AnimationController? _staticCloudController;

  // Get vertical position for static cloud based on configuration
  double _getStaticCloudYPosition() {
    switch (widget.staticCloudPosition) {
      case StaticCloudPosition.above:
        return widget.yPositionStart * 0.5;
      case StaticCloudPosition.below:
        return widget.yPositionEnd + 0.1;
      case StaticCloudPosition.inline:
        return (widget.yPositionStart + widget.yPositionEnd) / 2;
      case StaticCloudPosition.none:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize static cloud if needed
    if (widget.showStaticCloud) {
      _staticCloudController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat();
    } else {
      _staticCloudController = null;
    }

    // Initialize moving clouds
    _initializeClouds();
  }

  void _initializeClouds() {
    // Create specified number of moving clouds
    for (int i = 0; i < widget.numberOfMovingClouds; i++) {
      _createNewCloud();
    }
  }

  void _createNewCloud() {
    // Randomly decide direction (left-to-right or right-to-left)
    final bool movingRight = _random.nextBool();

    // Start and end positions well outside the screen
    final startPosition = movingRight ? -1.0 : 2.0;
    final endPosition = movingRight ? 2.0 : -1.0;

    // Random vertical position within specified range
    final yPosition =
        widget.yPositionStart +
        _random.nextDouble() * (widget.yPositionEnd - widget.yPositionStart);

    // Random duration between 20-40 seconds for varying speeds
    final duration = _random.nextInt(20) + 20;

    // Random scale based on base scale
    final scale =
        (widget.movingCloudBaseScale * 0.7) +
        (_random.nextDouble() * widget.movingCloudBaseScale * 0.6);

    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );

    final animation = Tween<Offset>(
      begin: Offset(startPosition, yPosition),
      end: Offset(endPosition, yPosition),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    // Add cloud data to list
    _clouds.add(
      CloudData(
        controller: controller,
        animation: animation,
        scale: scale,
        movingRight: movingRight,
      ),
    );

    // Start animation
    controller.forward().then((_) {
      // Remove cloud when animation completes
      if (mounted) {
        setState(() {
          _clouds.remove(
            _clouds.firstWhere((cloud) => cloud.controller == controller),
          );
          controller.dispose();
          // Create a new cloud to replace the removed one
          _createNewCloud();
        });
      }
    });
  }

  @override
  void dispose() {
    _staticCloudController?.dispose();
    for (var cloud in _clouds) {
      cloud.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Moving clouds
          ..._clouds.map(
            (cloud) => SlideTransition(
              position: cloud.animation,
              child: Transform.scale(
                scale: cloud.scale,
                child: Lottie.asset(
                  'assets/animations/cloud2.json',
                  width: 150,
                  reverse: !cloud.movingRight,
                ),
              ),
            ),
          ),

          // Static cloud
          if (widget.showStaticCloud &&
              widget.staticCloudPosition != StaticCloudPosition.none)
            Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  _getStaticCloudYPosition(),
              left: MediaQuery.of(context).size.width * 0.3,
              child: Transform.scale(
                scale: widget.staticCloudScale,
                child: Lottie.asset(
                  'assets/animations/cloud1.json',
                  controller: _staticCloudController,
                  width: 200,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CloudData {
  final AnimationController controller;
  final Animation<Offset> animation;
  final double scale;
  final bool movingRight;

  CloudData({
    required this.controller,
    required this.animation,
    required this.scale,
    required this.movingRight,
  });
}
