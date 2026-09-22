import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final bool enable3dHover;
  final double tiltX;
  final double tiltY;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20.0,
    this.blur = 16.0,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.shadows,
    this.enable3dHover = false,
    this.tiltX = 0.0,
    this.tiltY = 0.0,
    this.onTap,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  double _currentTiltX = 0.0;
  double _currentTiltY = 0.0;

  @override
  void initState() {
    super.initState();
    _currentTiltX = widget.tiltX;
    _currentTiltY = widget.tiltY;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant GlassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tiltX != widget.tiltX || oldWidget.tiltY != widget.tiltY) {
      _currentTiltX = widget.tiltX;
      _currentTiltY = widget.tiltY;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Colors.white.withOpacity(0.65);
    final effectiveBorderColor =
        widget.borderColor ?? Colors.white.withOpacity(0.5);

    final transformMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective depth
      ..rotateX(_currentTiltX)
      ..rotateY(_currentTiltY);

    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: effectiveColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: effectiveBorderColor,
                width: widget.borderWidth,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.enable3dHover || widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) {
          if (widget.onTap != null) _animController.forward();
        },
        onTapUp: (_) {
          if (widget.onTap != null) _animController.reverse();
        },
        onTapCancel: () {
          if (widget.onTap != null) _animController.reverse();
        },
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: transformMatrix..scale(_scaleAnimation.value),
              child: child,
            );
          },
          child: cardContent,
        ),
      );
    }

    return Transform(
      alignment: Alignment.center,
      transform: transformMatrix,
      child: cardContent,
    );
  }
}

