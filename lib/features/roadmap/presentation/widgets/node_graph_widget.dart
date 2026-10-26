import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/node_topic.dart';

class NodeGraphWidget extends StatelessWidget {
  final List<NodeTopic> topics;
  final void Function(NodeTopic topic) onNodeTap;

  const NodeGraphWidget({
    super.key,
    required this.topics,
    required this.onNodeTap,
  });

  static const double nodeDiameter = 68.0;
  static const double nodeRadius = nodeDiameter / 2;
  static const double stepHeight = 150.0;
  static const double horizontalOffset = 64.0;
  static const double topPadding = 50.0;

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) {
      return const Center(child: Text('Tidak ada topik roadmap.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final centerX = totalWidth / 2;
        final totalHeight = topPadding + (topics.length - 1) * stepHeight + 120.0;

        // Hitung posisi (x, y) titik pusat setiap node
        final nodeCenters = List.generate(topics.length, (index) {
          final isLeft = index % 2 == 0;
          final x = isLeft ? centerX - horizontalOffset : centerX + horizontalOffset;
          final y = topPadding + index * stepHeight;
          return Offset(x, y);
        });

        return SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Garis konektor dinamis menggunakan CustomPainter
              Positioned.fill(
                child: CustomPaint(
                  painter: _RoadmapConnectorPainter(
                    nodeCenters: nodeCenters,
                    topics: topics,
                  ),
                ),
              ),

              // 2. Daftar Node interaktif (Completed, InProgress, Locked)
              ...List.generate(topics.length, (index) {
                final topic = topics[index];
                final center = nodeCenters[index];

                return Positioned(
                  left: center.dx - 80,
                  top: center.dy - nodeRadius,
                  width: 160,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Node Lingkaran Interaktif
                      _buildNodeCircle(topic),
                      const SizedBox(height: 10),

                      // Label Judul & XP Reward
                      _buildNodeLabel(topic),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Tampilan Visual Lingkaran Node
  Widget _buildNodeCircle(NodeTopic topic) {
    Widget childIcon;
    List<BoxShadow> shadows = [];
    Gradient backgroundGradient;
    Border? border;

    switch (topic.status) {
      case NodeStatus.completed:
        // Completed: Lingkaran hijau toska dengan ikon centang
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        border = Border.all(color: const Color(0xFF34D399), width: 2.5);
        shadows = [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ];
        childIcon = const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 32,
        );
        break;

      case NodeStatus.inProgress:
        // InProgress: Lingkaran biru/cyan dengan efek glowing & border tebal
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        border = Border.all(color: Colors.white, width: 3.5);
        shadows = [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.65),
            blurRadius: 22,
            spreadRadius: 3,
            offset: const Offset(0, 4),
          ),
        ];
        childIcon = const Icon(
          Icons.play_arrow_rounded,
          color: AppColors.primaryNavy,
          size: 38,
        );
        break;

      case NodeStatus.locked:
        // Locked: Lingkaran abu-abu gelap dengan ikon gembok terkunci
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        border = Border.all(color: AppColors.border, width: 1.5);
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ];
        childIcon = const Icon(
          Icons.lock_rounded,
          color: AppColors.textSubtle,
          size: 24,
        );
        break;
    }

    final circle = GestureDetector(
      onTap: () => onNodeTap(topic),
      child: Container(
        width: nodeDiameter,
        height: nodeDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: backgroundGradient,
          border: border,
          boxShadow: shadows,
        ),
        child: Center(child: childIcon),
      ),
    );

    // Animasi denyut halus untuk status inProgress
    if (topic.status.isInProgress) {
      return circle
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.06, 1.06),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          );
    }

    return circle;
  }

  /// Label Kapsul di Bawah Node
  Widget _buildNodeLabel(NodeTopic topic) {
    final isLocked = topic.status.isLocked;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: topic.status.isInProgress
              ? AppColors.accentCyan.withValues(alpha: 0.5)
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            topic.title,
            style: TextStyle(
              color: isLocked ? AppColors.textSubtle : AppColors.textWhite,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt_rounded,
                color: isLocked ? AppColors.textSubtle : AppColors.xpGold,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                '+${topic.xpReward} XP',
                style: TextStyle(
                  color: isLocked ? AppColors.textSubtle : AppColors.xpGold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// CustomPainter untuk menggambar garis kurva penghubung dinamis antar node zig-zag
class _RoadmapConnectorPainter extends CustomPainter {
  final List<Offset> nodeCenters;
  final List<NodeTopic> topics;

  _RoadmapConnectorPainter({
    required this.nodeCenters,
    required this.topics,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.length < 2) return;

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final start = nodeCenters[i];
      final end = nodeCenters[i + 1];
      final targetTopic = topics[i + 1];

      // Tentukan apakah konektor sudah terbuka/aktif
      final isUnlocked = !targetTopic.status.isLocked;

      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isUnlocked ? 4.5 : 3.0
        ..strokeCap = StrokeCap.round;

      if (isUnlocked) {
        // Efek garis gradien toska/cyan
        paint.color = AppColors.accentCyan;
      } else {
        // Garis redup untuk node terkunci
        paint.color = AppColors.border;
      }

      final path = Path();
      path.moveTo(start.dx, start.dy);

      // Kurva Bezier halus menghubungkan sisi zig-zag (S-Curve)
      final midY = (start.dy + end.dy) / 2;
      path.cubicTo(
        start.dx,
        midY,
        end.dx,
        midY,
        end.dx,
        end.dy,
      );

      // Gambar glow subtle jika unlocked
      if (isUnlocked) {
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.0
          ..strokeCap = StrokeCap.round
          ..color = AppColors.accentCyan.withValues(alpha: 0.2);
        canvas.drawPath(path, glowPaint);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoadmapConnectorPainter oldDelegate) {
    return oldDelegate.nodeCenters != nodeCenters || oldDelegate.topics != topics;
  }
}
