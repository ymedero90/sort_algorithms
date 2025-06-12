import 'package:flutter/material.dart';

import 'pages/sorting_visualizer_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Algorithms Visualizer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SortingVisualizerPage(),
    );
  }
}
