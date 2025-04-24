import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StaticCloudPosition {
  above, // Static cloud appears above moving clouds
  inline, // Static cloud appears in the same line as moving clouds
  below, // Static cloud appears below moving clouds
  none, // No static cloud
}

enum CloudAnimationStyle {
  linear, // Simple linear movement
  floating, // Up and down while moving
  swaying, // Side to side while moving
  bouncing, // Bouncing effect
}

class CloudAnimation extends StatefulWidget {
  final int numberOfMovingClouds;
  final bool showStaticCloud;
  final StaticCloudPosition staticCloudPosition;
  final double staticCloudScale;
  final double movingCloudBaseScale;
  final double yPositionStart;
  final double yPositionEnd;
  final bool randomizeAnimations;

  const CloudAnimation({
    super.key,
    this.numberOfMovingClouds = 5,
    this.showStaticCloud = true,
    this.staticCloudPosition = StaticCloudPosition.above,
    this.staticCloudScale = 1.0,
    this.movingCloudBaseScale = 0.5,
    this.yPositionStart = 0.1,
    this.yPositionEnd = 0.4,
    this.randomizeAnimations = true,
  });

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation>
    with TickerProviderStateMixin {
  final List<CloudData> _clouds = [];
  final Random _random = Random();
  late final AnimationController? _staticCloudController;
  late final Animation<double>? _staticCloudAnimation;

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

  CloudAnimationStyle _getRandomStyle() {
    if (!widget.randomizeAnimations) return CloudAnimationStyle.linear;
    return CloudAnimationStyle.values[_random.nextInt(
      CloudAnimationStyle.values.length,
    )];
  }

  @override
  void initState() {
    super.initState();

    // Initialize static cloud if needed
    if (widget.showStaticCloud) {
      _staticCloudController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);

      _staticCloudAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
        CurvedAnimation(
          parent: _staticCloudController!,
          curve: Curves.easeInOut,
        ),
      );
    } else {
      _staticCloudController = null;
      _staticCloudAnimation = null;
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
    final baseYPosition =
        widget.yPositionStart +
        _random.nextDouble() * (widget.yPositionEnd - widget.yPositionStart);

    // Random duration between 20-40 seconds for varying speeds
    final duration = _random.nextInt(20) + 20;

    // Random scale based on base scale
    final scale =
        (widget.movingCloudBaseScale * 0.7) +
        (_random.nextDouble() * widget.movingCloudBaseScale * 0.6);

    final style = _getRandomStyle();
    final controllers = <AnimationController>[];
    final animations = <Animation>[];

    // Main movement controller
    final mainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );
    controllers.add(mainController);

    // Base horizontal movement
    final moveAnimation = Tween<Offset>(
      begin: Offset(startPosition, baseYPosition),
      end: Offset(endPosition, baseYPosition),
    ).animate(CurvedAnimation(parent: mainController, curve: Curves.linear));
    animations.add(moveAnimation);

    // Add style-specific animations
    switch (style) {
      case CloudAnimationStyle.floating:
        final floatController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 3),
        )..repeat(reverse: true);
        controllers.add(floatController);

        final floatAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
          CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
        );
        animations.add(floatAnimation);
        break;

      case CloudAnimationStyle.swaying:
        final swayController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2),
        )..repeat(reverse: true);
        controllers.add(swayController);

        final swayAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
          CurvedAnimation(parent: swayController, curve: Curves.easeInOut),
        );
        animations.add(swayAnimation);
        break;

      case CloudAnimationStyle.bouncing:
        final bounceController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1),
        )..repeat();
        controllers.add(bounceController);

        final bounceAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
          CurvedAnimation(parent: bounceController, curve: Curves.bounceOut),
        );
        animations.add(bounceAnimation);
        break;

      case CloudAnimationStyle.linear:
        // No additional animations needed
        break;
    }

    _clouds.add(
      CloudData(
        controllers: controllers,
        animations: animations,
        scale: scale,
        movingRight: movingRight,
        style: style,
      ),
    );

    // Start all animations
    for (var controller in controllers) {
      controller.forward();
    }

    // Handle completion of main movement
    mainController.forward().then((_) {
      if (mounted) {
        setState(() {
          final cloudToRemove = _clouds.firstWhere(
            (cloud) => cloud.controllers.contains(mainController),
          );
          _clouds.remove(cloudToRemove);
          // Dispose all controllers
          for (var controller in cloudToRemove.controllers) {
            controller.dispose();
          }
          // Create a new cloud
          _createNewCloud();
        });
      }
    });
  }

  @override
  void dispose() {
    _staticCloudController?.dispose();
    for (var cloud in _clouds) {
      for (var controller in cloud.controllers) {
        controller.dispose();
      }
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
          ..._clouds.map((cloud) {
            Widget cloudWidget = Transform.scale(
              scale: cloud.scale,
              child: Lottie.asset(
                'assets/animations/cloud2.json',
                width: 150,
                reverse: !cloud.movingRight,
              ),
            );

            // Apply animations based on style
            switch (cloud.style) {
              case CloudAnimationStyle.floating:
                cloudWidget = SlideTransition(
                  position: cloud.animations[0] as Animation<Offset>,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (cloud.animations[1] as Animation<double>).value * 100,
                    ),
                    child: cloudWidget,
                  ),
                );
                break;

              case CloudAnimationStyle.swaying:
                cloudWidget = SlideTransition(
                  position: cloud.animations[0] as Animation<Offset>,
                  child: Transform.translate(
                    offset: Offset(
                      (cloud.animations[1] as Animation<double>).value * 50,
                      0,
                    ),
                    child: cloudWidget,
                  ),
                );
                break;

              case CloudAnimationStyle.bouncing:
                cloudWidget = SlideTransition(
                  position: cloud.animations[0] as Animation<Offset>,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (cloud.animations[1] as Animation<double>).value * 30,
                    ),
                    child: cloudWidget,
                  ),
                );
                break;

              case CloudAnimationStyle.linear:
                cloudWidget = SlideTransition(
                  position: cloud.animations[0] as Animation<Offset>,
                  child: cloudWidget,
                );
                break;
            }

            return cloudWidget;
          }),

          // Static cloud with floating animation
          if (widget.showStaticCloud &&
              widget.staticCloudPosition != StaticCloudPosition.none)
            Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  _getStaticCloudYPosition(),
              left: MediaQuery.of(context).size.width * 0.3,
              child: AnimatedBuilder(
                animation: _staticCloudAnimation!,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _staticCloudAnimation.value * 20),
                    child: Transform.scale(
                      scale: widget.staticCloudScale,
                      child: Lottie.asset(
                        'assets/animations/cloud1.json',
                        controller: _staticCloudController,
                        width: 200,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CloudData {
  final List<AnimationController> controllers;
  final List<Animation> animations;
  final double scale;
  final bool movingRight;
  final CloudAnimationStyle style;

  CloudData({
    required this.controllers,
    required this.animations,
    required this.scale,
    required this.movingRight,
    required this.style,
  });
}
