import 'package:flutter/material.dart';

import '../controllers/configuration_controller.dart';
import '../models/sorting_algorithm.dart';
import '../theme/app_theme.dart';

class MobileConfigurationPanel extends StatelessWidget {
  final ConfigurationController controller;

  const MobileConfigurationPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    print('⚙️ Building MobileConfigurationPanel'); // Debug
    return Container(
      color: AppTheme.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlgorithmSelection(),
            const SizedBox(height: 24),
            _buildArrayConfiguration(),
            const SizedBox(height: 24),
            _buildSpeedControl(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            if (controller.selectedAlgorithm != null) _buildComplexityInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmSelection() {
    return _buildSection(
      'Algorithm Selection',
      Icons.psychology,
      DropdownButtonFormField<SortingAlgorithm>(
        value: controller.selectedAlgorithm,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: AppTheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
        dropdownColor: AppTheme.surface,
        style: const TextStyle(color: AppTheme.text),
        items:
            controller.availableAlgorithms.map((algorithm) {
              return DropdownMenuItem(value: algorithm, child: Text(algorithm.name));
            }).toList(),
        onChanged: controller.selectAlgorithm,
      ),
    );
  }

  Widget _buildArrayConfiguration() {
    return _buildSection(
      'Array Configuration',
      Icons.view_list,
      Column(
        children: [
          TextFormField(
            controller: controller.arraySizeController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppTheme.text),
            decoration: InputDecoration(
              labelText: 'Array Size',
              hintText: 'e.g: 8 (max: 64)',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            onChanged: controller.updateArraySize,
            onEditingComplete: controller.handleArraySizeInputComplete,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.generateNewArray,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Generate New Array'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sorted,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControl() {
    return _buildSection(
      'Animation Speed: ${controller.animationSpeed.toStringAsFixed(1)}x',
      Icons.speed,
      Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.primary,
              thumbColor: AppTheme.primary,
              inactiveTrackColor: AppTheme.divider,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: controller.animationSpeed,
              min: 0.1,
              max: 2.0,
              divisions: 38,
              onChanged: controller.updateAnimationSpeed,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Slow', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text('Fast', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return _buildSection(
      'Controls',
      Icons.play_circle,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.startPauseAnimation,
                  icon: Icon(controller.playButtonIcon, size: 18),
                  label: Text(controller.playButtonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.playButtonColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.resetVisualization,
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.normal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplexityInfo() {
    return _buildSection(
      'Algorithm Complexity',
      Icons.analytics,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildComplexityCard('Time', controller.selectedAlgorithm!.timeComplexity, AppTheme.swapping),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildComplexityCard('Space', controller.selectedAlgorithm!.spaceComplexity, AppTheme.normal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.selectedAlgorithm!.isStable ? Icons.check_circle : Icons.warning,
                  color: controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.selectedAlgorithm!.isStable ? 'Stable' : 'Unstable',
                  style: TextStyle(
                    color: controller.selectedAlgorithm!.isStable ? AppTheme.sorted : AppTheme.comparing,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: AppTheme.text, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildComplexityCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
