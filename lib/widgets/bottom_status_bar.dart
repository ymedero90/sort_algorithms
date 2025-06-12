import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BottomStatusBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const BottomStatusBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      color: AppTheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Step $currentStep of $totalSteps',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          InkWell(
            onTap: canGoPrevious ? onPrevious : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Icon(Icons.skip_previous, color: canGoPrevious ? Colors.white : Colors.white54, size: 16),
            ),
          ),
          InkWell(
            onTap: canGoNext ? onNext : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Icon(Icons.skip_next, color: canGoNext ? Colors.white : Colors.white54, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
