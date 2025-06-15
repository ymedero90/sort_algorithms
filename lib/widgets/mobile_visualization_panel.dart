import 'package:flutter/material.dart';

import '../controllers/visualization_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/array_visualizer.dart';

class MobileVisualizationPanel extends StatelessWidget {
  final VisualizationController controller;
  final AnimationController pulseController;

  const MobileVisualizationPanel({super.key, required this.controller, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    print('🎨 Building MobileVisualizationPanel'); // Debug
    return Container(
      color: AppTheme.background,
      child: Column(
        children: [
          _buildLegend(),
          Expanded(
            child:
                controller.hasSteps && controller.currentStep != null
                    ? ArrayVisualizer(
                      step: controller.currentStep!,
                      animationController: pulseController,
                      isMobile: true,
                    )
                    : _buildEmptyState(),
          ),
          _buildPseudocodeSection(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              controller.legendItems
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildLegendItem(item.color, item.label),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48, color: AppTheme.textSecondary),
          SizedBox(height: 16),
          Text('Generate an array to start', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPseudocodeSection() {
    if (controller.selectedAlgorithm == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      color: AppTheme.surface,
      child: Column(
        children: [
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.code, color: AppTheme.primary, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'PSEUDOCODE',
                  style: TextStyle(color: AppTheme.text, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (controller.currentPseudocodeLine != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Line ${(controller.currentPseudocodeLine! + 1)}',
                      style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    controller.selectedAlgorithm!.pseudocode.asMap().entries.map((entry) {
                      final index = entry.key;
                      final line = entry.value;
                      final isCurrentLine = controller.currentPseudocodeLine == index;

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: isCurrentLine ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrentLine ? AppTheme.primary : AppTheme.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isCurrentLine) ...[
                              const Icon(Icons.play_arrow, color: AppTheme.primary, size: 12),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                line.trim(),
                                style: TextStyle(
                                  color: isCurrentLine ? AppTheme.text : AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: isCurrentLine ? FontWeight.w600 : FontWeight.normal,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
