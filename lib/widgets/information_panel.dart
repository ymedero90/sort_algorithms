import 'package:flutter/material.dart';

import '../controllers/information_controller.dart';
import '../theme/app_theme.dart';

class InformationPanel extends StatelessWidget {
  final InformationController controller;

  const InformationPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.hasAlgorithm) {
      return const Center(
        child: Text(
          'Select an algorithm to view information',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    return Container(
      color: AppTheme.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlgorithmHeader(),
            const SizedBox(height: 32),
            _buildComplexityAnalysis(),
            const SizedBox(height: 32),
            _buildAdvantages(),
            const SizedBox(height: 32),
            _buildDisadvantages(),
            if (controller.hasSpecificInfo) ...[const SizedBox(height: 32), _buildSpecificInfo()],
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.algorithmName,
                style: const TextStyle(color: AppTheme.text, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                controller.algorithmDescription,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplexityAnalysis() {
    return _buildInfoSection(
      'Complexity Analysis',
      Icons.analytics,
      AppTheme.swapping,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComplexityCard(
            'Time Complexity: ${controller.timeComplexity}',
            controller.timeComplexityExplanation,
            Icons.access_time,
            AppTheme.swapping,
          ),
          const SizedBox(height: 16),
          _buildComplexityCard(
            'Space Complexity: ${controller.spaceComplexity}',
            controller.spaceComplexityExplanation,
            Icons.memory,
            AppTheme.normal,
          ),
          const SizedBox(height: 16),
          _buildComplexityCard(
            'Stability: ${controller.isStable ? 'Stable' : 'Unstable'}',
            controller.stabilityExplanation,
            controller.isStable ? Icons.check_circle : Icons.warning,
            controller.isStable ? AppTheme.sorted : AppTheme.comparing,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantages() {
    return _buildInfoSection(
      'Advantages',
      Icons.thumb_up,
      AppTheme.sorted,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            controller.advantages.map((advantage) => _buildListItem(advantage, AppTheme.sorted, Icons.check)).toList(),
      ),
    );
  }

  Widget _buildDisadvantages() {
    return _buildInfoSection(
      'Disadvantages',
      Icons.thumb_down,
      AppTheme.swapping,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            controller.disadvantages
                .map((disadvantage) => _buildListItem(disadvantage, AppTheme.swapping, Icons.close))
                .toList(),
      ),
    );
  }

  Widget _buildSpecificInfo() {
    return Column(
      children:
          controller.specificInfoSections
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildInfoSection(
                    section.title,
                    Icons.psychology,
                    section.color,
                    _buildInfoCard(section.title, section.items, section.color),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, Color color, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildComplexityCard(String title, String explanation, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(explanation, style: const TextStyle(color: AppTheme.text, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: AppTheme.text, fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: const TextStyle(color: AppTheme.text, fontSize: 14, height: 1.4))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
