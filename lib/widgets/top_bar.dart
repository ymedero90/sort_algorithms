import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: AppTheme.header,
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.sort, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Sorting Algorithms Visualizer',
            style: TextStyle(color: AppTheme.text, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
