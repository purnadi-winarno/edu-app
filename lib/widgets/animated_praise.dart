import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PraiseAnimationStyle { zoomIn, flyIn, typing, bounce, spin, fade }

class AnimatedPraise extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const AnimatedPraise({super.key, this.onAnimationComplete});

  @override
  State<AnimatedPraise> createState() => _AnimatedPraiseState();
}

class _AnimatedPraiseState extends State<AnimatedPraise>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final PraiseAnimationStyle _animationStyle;
  String? _praiseMessage;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationStyle =
        PraiseAnimationStyle.values[_random.nextInt(
          PraiseAnimationStyle.values.length,
        )];

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Start animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward().then((_) {
        widget.onAnimationComplete?.call();
      });
    });
  }

  String _getRandomPraiseMessage(AppLocalizations localizations) {
    final messages = [
      localizations.praiseMessage1,
      localizations.praiseMessage2,
      localizations.praiseMessage3,
      localizations.praiseMessage4,
      localizations.praiseMessage5,
      localizations.praiseMessage6,
      localizations.praiseMessage7,
      localizations.praiseMessage8,
      localizations.praiseMessage9,
      localizations.praiseMessage10,
    ];
    return messages[_random.nextInt(messages.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    _praiseMessage ??= _getRandomPraiseMessage(localizations);

    Widget child = _buildText();

    switch (_animationStyle) {
      case PraiseAnimationStyle.zoomIn:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(_animation),
          child: child,
        );

      case PraiseAnimationStyle.flyIn:
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(_random.nextBool() ? -2.0 : 2.0, 0),
            end: Offset.zero,
          ).animate(_animation),
          child: FadeTransition(opacity: _animation, child: child),
        );

      case PraiseAnimationStyle.typing:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final length =
                (_praiseMessage!.length * _animation.value)
                    .clamp(0, _praiseMessage!.length)
                    .round();
            return _buildText(text: _praiseMessage!.substring(0, length));
          },
        );

      case PraiseAnimationStyle.bounce:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final bounce =
                sin(_animation.value * 3 * pi) * (1 - _animation.value) * 0.25;
            return Transform.translate(
              offset: Offset(0, bounce * 50),
              child: FadeTransition(opacity: _animation, child: child),
            );
          },
        );

      case PraiseAnimationStyle.spin:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Transform.rotate(
              angle: _animation.value * 2 * pi,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(_animation),
                child: FadeTransition(opacity: _animation, child: child),
              ),
            );
          },
        );

      case PraiseAnimationStyle.fade:
        return FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(_animation),
            child: child,
          ),
        );
    }
  }

  Widget _buildText({String? text}) {
    return Text(
      text ?? _praiseMessage!,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
