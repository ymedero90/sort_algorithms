import 'package:flutter/material.dart';

import '../controllers/visualization_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/array_visualizer.dart';
import '../widgets/pseudocode_viewer.dart';

class VisualizationPanel extends StatelessWidget {
  final VisualizationController controller;
  final AnimationController pulseController;

  const VisualizationPanel({super.key, required this.controller, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [_buildArrayVisualization(), Container(width: 1, color: AppTheme.divider), _buildPseudocodePanel()],
    );
  }

  Widget _buildArrayVisualization() {
    if (controller.isVisualizationCollapsed) {
      return _buildCollapsedVisualization();
    }

    return Expanded(
      flex: 3,
      child: Container(
        color: AppTheme.background,
        child: Column(
          children: [
            _buildVisualizationHeader(),
            _buildLegend(),
            Expanded(
              child:
                  controller.hasSteps && controller.currentStep != null
                      ? ArrayVisualizer(step: controller.currentStep!, animationController: pulseController)
                      : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPseudocodePanel() {
    if (controller.isPseudocodeCollapsed) {
      return _buildCollapsedPseudocode();
    }

    return Expanded(
      flex: 2,
      child: Container(
        color: AppTheme.background,
        child: Column(
          children: [
            _buildPseudocodeHeader(),
            Expanded(
              child:
                  controller.selectedAlgorithm != null
                      ? PseudocodeViewer(
                        algorithm: controller.selectedAlgorithm!,
                        currentLine: controller.currentPseudocodeLine,
                        showHeader: false,
                      )
                      : _buildSelectAlgorithmState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedVisualization() {
    return Container(
      width: 35,
      color: AppTheme.surface,
      child: Column(
        children: [
          InkWell(
            onTap: controller.toggleVisualization,
            child: SizedBox(
              height: 35,
              child: const Center(child: Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 16)),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: Center(
                child: Text(
                  'VISUALIZATION',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationHeader() {
    return Container(
      height: 35,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.bar_chart, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'VISUALIZATION',
            style: TextStyle(color: AppTheme.text, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const Spacer(),
          InkWell(
            onTap: controller.toggleVisualization,
            child: const Icon(Icons.chevron_left, color: AppTheme.textSecondary, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            controller.legendItems
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _buildLegendItem(item.color, item.label),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)],
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
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

  Widget _buildCollapsedPseudocode() {
    return Container(
      width: 35,
      color: AppTheme.surface,
      child: Column(
        children: [
          InkWell(
            onTap: controller.togglePseudocode,
            child: SizedBox(
              height: 35,
              child: const Center(child: Icon(Icons.chevron_left, color: AppTheme.textSecondary, size: 16)),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: 1,
              child: Center(
                child: Text(
                  'PSEUDOCODE',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPseudocodeHeader() {
    return Container(
      height: 35,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.code, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'PSEUDOCODE',
            style: TextStyle(color: AppTheme.text, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const Spacer(),
          InkWell(
            onTap: controller.togglePseudocode,
            child: const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAlgorithmState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, size: 48, color: AppTheme.textSecondary),
          SizedBox(height: 16),
          Text('Select an algorithm', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}
