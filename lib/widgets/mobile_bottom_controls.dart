import 'package:flutter/material.dart';

import '../controllers/configuration_controller.dart';
import '../theme/app_theme.dart';

class MobileBottomControls extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ConfigurationController configController;

  const MobileBottomControls({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.configController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Play/Pause button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: configController.startPauseAnimation,
                      icon: Icon(configController.playButtonIcon, size: 18),
                      label: Text(configController.playButtonText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: configController.playButtonColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Reset button
                  ElevatedButton(
                    onPressed: configController.resetVisualization,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.normal,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Icon(Icons.replay, size: 18),
                  ),
                  const SizedBox(width: 8),
                  // Generate button
                  ElevatedButton(
                    onPressed: configController.generateNewArray,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sorted,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Icon(Icons.refresh, size: 18),
                  ),
                ],
              ),
            ),

            // Step navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppTheme.divider))),
              child: Row(
                children: [
                  // Previous button
                  IconButton(
                    onPressed: canGoPrevious ? onPrevious : null,
                    icon: Icon(Icons.skip_previous, color: canGoPrevious ? AppTheme.primary : AppTheme.textSecondary),
                  ),

                  // Step info
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            'Step $currentStep of $totalSteps',
                            style: const TextStyle(color: AppTheme.text, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: totalSteps > 0 ? currentStep / totalSteps : 0,
                            backgroundColor: AppTheme.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Next button
                  IconButton(
                    onPressed: canGoNext ? onNext : null,
                    icon: Icon(Icons.skip_next, color: canGoNext ? AppTheme.primary : AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
