import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class DeveloperInfoDialog extends StatelessWidget {
  const DeveloperInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, color: AppTheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the Developer',
                        style: TextStyle(color: AppTheme.text, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sorting Algorithms Visualizer',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Developer info
            _buildInfoSection(),

            const SizedBox(height: 24),

            // Contact links
            _buildContactSection(),

            const SizedBox(height: 20),

            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: AppTheme.primary, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yoel Medero Vargas',
                      style: TextStyle(color: AppTheme.text, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Senior Flutter Developer',
                      style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Passionate about creating beautiful and functional mobile applications with Flutter. '
            'This sorting algorithms visualizer was built to help students and developers '
            'understand how different sorting algorithms work through interactive visualization.',
            style: TextStyle(color: AppTheme.text, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Get in touch', style: TextStyle(color: AppTheme.text, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildContactItem(Icons.email, 'Email', 'ymedero90@gmail.com', () => _copyToClipboard('ymedero90@gmail.com')),
        const SizedBox(height: 8),
        _buildContactItem(
          Icons.business,
          'LinkedIn',
          'linkedin.com/in/yoel-medero-vargas-0a661ba7/',
          () => _copyToClipboard('https://www.linkedin.com/in/yoel-medero-vargas-0a661ba7/'),
        ),
        const SizedBox(height: 8),
        _buildContactItem(
          Icons.code,
          'GitHub',
          'github.com/ymedero90',
          () => _copyToClipboard('https://github.com/ymedero90'),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              '$label: ',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Expanded(child: Text(value, style: const TextStyle(color: AppTheme.primary, fontSize: 12))),
            const Icon(Icons.copy, color: AppTheme.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
