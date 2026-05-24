import 'package:flutter/material.dart';
import 'dart:math' as math;

class RollingBall extends StatelessWidget {
  final double size;
  final double progress;
  final Color ballColor;
  final Color patternColor;

  const RollingBall({
    super.key,
    this.size = 50,
    required this.progress,
    this.ballColor = Colors.white,
    this.patternColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    // progress usually goes from 0.0 to 1.0
    // We'll use it to rotate the ball
    return Transform.rotate(
      angle: progress * 2 * math.pi * 2, // 2 full rotations
      child: CustomPaint(
        size: Size(size, size),
        painter: SoccerBallPainter(
          ballColor: ballColor,
          patternColor: patternColor,
        ),
      ),
    );
  }
}

class SoccerBallPainter extends CustomPainter {
  final Color ballColor;
  final Color patternColor;

  SoccerBallPainter({required this.ballColor, required this.patternColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ballPaint = Paint()
      ..color = ballColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = patternColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw the ball base
    canvas.drawCircle(center, radius, ballPaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw soccer patterns (pentagons)
    final patternPaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.fill;

    // Center pentagon
    _drawPentagon(canvas, center, radius * 0.35, patternPaint);

    // Surrounding pentagons
    for (int i = 0; i < 5; i++) {
      double angle = (i * 72) * math.pi / 180;
      Offset pentagonCenter = Offset(
        center.dx + radius * 0.7 * math.cos(angle),
        center.dy + radius * 0.7 * math.sin(angle),
      );
      _drawPentagon(canvas, pentagonCenter, radius * 0.3, patternPaint, rotation: angle + math.pi);
    }
    
    // Add some shading for 3D effect
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withOpacity(0.2)],
        stops: const [0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, shadowPaint);
  }

  void _drawPentagon(Canvas canvas, Offset center, double radius, Paint paint, {double rotation = 0}) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (i * 72) * math.pi / 180 + rotation;
      double x = center.dx + radius * math.cos(angle);
      double y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FeatureBallAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const FeatureBallAnimation({super.key, required this.child, required this.onTap});

  @override
  State<FeatureBallAnimation> createState() => _FeatureBallAnimationState();
}

class _FeatureBallAnimationState extends State<FeatureBallAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    setState(() => _isAnimating = true);
    _controller.forward(from: 0).then((_) {
      setState(() => _isAnimating = false);
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAnimation,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_isAnimating)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(-50 + (_controller.value * 150), 0),
                    child: Center(
                      child: Opacity(
                        opacity: (1.0 - _controller.value).clamp(0.0, 1.0),
                        child: RollingBall(size: 24, progress: _controller.value),
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
