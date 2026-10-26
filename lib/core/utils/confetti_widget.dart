import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double rotation;
  double rotationSpeed;
  double wobble;
  double wobbleSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.wobble,
    required this.wobbleSpeed,
  });
}

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool isPlaying;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.isPlaying = true,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  static const List<Color> _palette = [
    AppColors.xpGold,
    AppColors.accentCyan,
    Color(0xFFA855F7), // Purple
    Color(0xFF10B981), // Emerald
    Color(0xFFF43F5E), // Rose
    Color(0xFF38BDF8), // Sky
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    if (widget.isPlaying) {
      _initParticles();
      _controller.forward();
    }

    _controller.addListener(() {
      setState(() {
        _updateParticles();
      });
    });
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < 70; i++) {
      final angle = _random.nextDouble() * pi * 2;
      final speed = 3.0 + _random.nextDouble() * 7.0;
      _particles.add(
        ConfettiParticle(
          x: 0.5,
          y: 0.25,
          vx: cos(angle) * speed * 0.0035,
          vy: (sin(angle) * speed * 0.0035) - 0.003, // slight upward impulse
          size: 6.0 + _random.nextDouble() * 6.0,
          color: _palette[_random.nextInt(_palette.length)],
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
          wobble: _random.nextDouble() * 2 * pi,
          wobbleSpeed: 0.05 + _random.nextDouble() * 0.08,
        ),
      );
    }
  }

  void _updateParticles() {
    for (var p in _particles) {
      p.x += p.vx + sin(p.wobble) * 0.001;
      p.y += p.vy;
      p.vy += 0.00018; // gravity
      p.rotation += p.rotationSpeed;
      p.wobble += p.wobbleSpeed;
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _initParticles();
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (var p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      if (py > size.height + 20) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);

      // Draw confetti rectangle with slight 3D perspective wobble
      final scaleX = cos(p.wobble);
      canvas.scale(scaleX, 1.0);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: p.size,
        height: p.size * 0.65,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
