import 'package:flutter/material.dart';

class FlickTVLogo extends StatelessWidget {
  final double fontSize;
  final bool showSubtitle;
  final LogoStyle style;

  const FlickTVLogo({
    Key? key,
    this.fontSize = 32,
    this.showSubtitle = false,
    this.style = LogoStyle.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMainLogo(),
        if (showSubtitle) ...[const SizedBox(height: 8), _buildSubtitle()],
      ],
    );
  }

  Widget _buildMainLogo() {
    return Container(
      height: fontSize * 1.2, // Maintain aspect ratio
      child: Image.asset(
        'assets/logo/flick.png',
        height: fontSize * 1.2,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to text logo if image fails to load
          return _buildFallbackText();
        },
      ),
    );
  }

  Widget _buildFallbackText() {
    switch (style) {
      case LogoStyle.gradient:
        return ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFE50914),
                  Color(0xFFFF6B6B),
                  Color(0xFFE50914),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ).createShader(bounds),
          child: _buildText(),
        );
      case LogoStyle.solid:
        return _buildText(color: const Color(0xFFE50914));
      case LogoStyle.white:
        return _buildText(color: Colors.white);
    }
  }

  Widget _buildText({Color? color}) {
    return Text(
      'FLICKTV',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: color ?? Colors.white,
        letterSpacing: fontSize * 0.08,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: fontSize * 0.3,
            offset: Offset(0, fontSize * 0.1),
          ),
          Shadow(
            color: const Color(0xFFE50914).withOpacity(0.4),
            blurRadius: fontSize * 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.3,
        vertical: fontSize * 0.1,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(fontSize * 0.5),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Text(
        'STREAM UNLIMITED ENTERTAINMENT',
        style: TextStyle(
          fontSize: fontSize * 0.25,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFE5E5E5),
          letterSpacing: fontSize * 0.05,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: fontSize * 0.2,
              offset: Offset(0, fontSize * 0.05),
            ),
          ],
        ),
      ),
    );
  }
}

enum LogoStyle { gradient, solid, white }

// Netflix-style animated logo for splash screens
class AnimatedFlickTVLogo extends StatefulWidget {
  final double fontSize;
  final bool showSubtitle;
  final Duration animationDuration;

  const AnimatedFlickTVLogo({
    Key? key,
    this.fontSize = 64,
    this.showSubtitle = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<AnimatedFlickTVLogo> createState() => _AnimatedFlickTVLogoState();
}

class _AnimatedFlickTVLogoState extends State<AnimatedFlickTVLogo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFFE50914,
                    ).withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: widget.fontSize * 0.8 * _glowAnimation.value,
                    spreadRadius: widget.fontSize * 0.1 * _glowAnimation.value,
                  ),
                ],
              ),
              child: FlickTVLogo(
                fontSize: widget.fontSize,
                showSubtitle: widget.showSubtitle,
                style: LogoStyle.gradient,
              ),
            ),
          ),
        );
      },
    );
  }
}
