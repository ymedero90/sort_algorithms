import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/developer_info_dialog.dart';

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
          // Developer info button
          InkWell(
            onTap: () => _showDeveloperInfo(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: AppTheme.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  const Text(
                    'Developer',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  void _showDeveloperInfo(BuildContext context) {
    showDialog(context: context, builder: (context) => const DeveloperInfoDialog());
  }
}
