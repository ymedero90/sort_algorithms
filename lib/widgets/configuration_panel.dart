import 'package:flutter/material.dart';

import '../controllers/configuration_controller.dart';
import '../models/sorting_algorithm.dart';
import '../theme/app_theme.dart';

class ConfigurationPanel extends StatelessWidget {
  final ConfigurationController controller;

  const ConfigurationPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isCollapsed) {
      return _buildCollapsedPanel();
    }
    return _buildExpandedPanel(context);
  }

  Widget _buildExpandedPanel(BuildContext context) {
    return Container(
      width: 300,
      color: AppTheme.surface,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAlgorithmSelection(),
                  const SizedBox(height: 20),
                  _buildArraySizeInput(context),
                  const SizedBox(height: 20),
                  _buildSpeedControl(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const Spacer(),
                  if (controller.selectedAlgorithm != null) _buildComplexityInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedPanel() {
    return Container(
      width: 35,
      color: AppTheme.surface,
      child: Column(children: [_buildCollapsedHeader(), _buildVerticalText(), _buildQuickActions()]),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 35,
      color: AppTheme.header,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.settings, color: AppTheme.text, size: 16),
          const SizedBox(width: 8),
          const Text(
            'CONFIGURATION',
            style: TextStyle(color: AppTheme.text, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const Spacer(),
          InkWell(
            onTap: controller.toggleCollapse,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.chevron_left, color: AppTheme.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Container(
      height: 35,
      color: AppTheme.header,
      child: InkWell(
        onTap: controller.toggleCollapse,
        child: const Center(child: Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 16)),
      ),
    );
  }

  Widget _buildVerticalText() {
    return Expanded(
      child: RotatedBox(
        quarterTurns: 3,
        child: Center(
          child: Text(
            'CONFIG',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          Tooltip(
            message: 'New Array',
            child: InkWell(
              onTap: controller.generateNewArray,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: AppTheme.sorted, borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.refresh, color: Colors.black, size: 14),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Tooltip(
            message: controller.playButtonText,
            child: InkWell(
              onTap: controller.startPauseAnimation,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: controller.playButtonColor, borderRadius: BorderRadius.circular(4)),
                child: Icon(controller.playButtonIcon, color: Colors.black, size: 14),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Tooltip(
            message: 'Reset',
            child: InkWell(
              onTap: controller.resetVisualization,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: AppTheme.normal, borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.replay, color: Colors.black, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmSelection() {
    return _buildSidebarSection(
      'Algorithm',
      DropdownButtonFormField<SortingAlgorithm>(
        value: controller.selectedAlgorithm,
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        dropdownColor: AppTheme.divider,
        style: const TextStyle(color: AppTheme.text),
        items:
            controller.availableAlgorithms.map((algorithm) {
              return DropdownMenuItem(value: algorithm, child: Text(algorithm.name));
            }).toList(),
        onChanged: controller.selectAlgorithm,
      ),
    );
  }

  Widget _buildArraySizeInput(BuildContext context) {
    return _buildSidebarSection(
      'Array Size',
      TextFormField(
        controller: controller.arraySizeController,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppTheme.text),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          hintText: 'e.g: 8 (max: 64)',
          hintStyle: TextStyle(color: AppTheme.textSecondary),
        ),
        onChanged: controller.updateArraySize,
        onEditingComplete: controller.handleArraySizeInputComplete,
      ),
    );
  }

  Widget _buildSpeedControl() {
    return _buildSidebarSection(
      'Speed: ${controller.animationSpeed.toStringAsFixed(1)}x',
      Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.primary,
              thumbColor: AppTheme.primary,
              inactiveTrackColor: AppTheme.divider,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: controller.animationSpeed,
              min: 0.1, // Muy lento
              max: 2.0, // Rápido pero controlado
              divisions: 38, // Más precisión (0.1, 0.15, 0.2, ..., 2.0)
              onChanged: controller.updateAnimationSpeed,
            ),
          ),
          // Indicadores de velocidad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Slow', style: TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
              Text('Fast', style: TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton('New Array', Icons.refresh, AppTheme.sorted, controller.generateNewArray),
        const SizedBox(height: 8),
        _buildActionButton(
          controller.playButtonText,
          controller.playButtonIcon,
          controller.playButtonColor,
          controller.startPauseAnimation,
        ),
        const SizedBox(height: 8),
        _buildActionButton('Reset', Icons.replay, AppTheme.normal, controller.resetVisualization),
      ],
    );
  }

  Widget _buildComplexityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COMPLEXITY',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildComplexityItem('Time', controller.selectedAlgorithm!.timeComplexity, AppTheme.swapping),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildComplexityItem('Space', controller.selectedAlgorithm!.spaceComplexity, AppTheme.normal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            controller.selectedAlgorithm!.isStable ? 'Stable' : 'Unstable',
            style: TextStyle(
              color: controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildComplexityItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
