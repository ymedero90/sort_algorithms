import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/sorting_algorithm.dart';

class PseudocodeViewer extends StatelessWidget {
  final SortingAlgorithm algorithm;
  final int? currentLine;
  final bool showHeader;

  const PseudocodeViewer({super.key, required this.algorithm, this.currentLine, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    if (algorithm.pseudocode.isEmpty) {
      return const Center(child: Text('Pseudocode not available', style: TextStyle(color: Color(0xFF858585))));
    }

    return Container(
      color: const Color(0xFF252526),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (opcional)
          if (showHeader)
            Container(
              height: 35,
              color: const Color(0xFF252526),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.code, color: Color(0xFF569CD6), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'PSEUDOCODE',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

          // Line numbers gutter and code
          Expanded(
            child: Row(
              children: [
                // Line numbers gutter
                Container(
                  width: 40,
                  color: const Color(0xFF252526),
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          algorithm.pseudocode.asMap().entries.map((entry) {
                            final index = entry.key;
                            final isCurrentLine = currentLine == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 20,
                              padding: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isCurrentLine ? const Color(0xFF094771) : Colors.transparent,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCurrentLine ? const Color(0xFFCCCCCC) : const Color(0xFF858585),
                                    fontFamily: 'FiraCode',
                                    fontWeight: isCurrentLine ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),

                // Vertical divider
                Container(width: 1, color: const Color(0xFF3C3C3C)),

                // Code content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          algorithm.pseudocode.asMap().entries.map((entry) {
                            final index = entry.key;
                            final line = entry.value;
                            final isCurrentLine = currentLine == index;
                            final indentLevel = _getIndentLevel(line);

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 20,
                              padding: EdgeInsets.only(left: indentLevel * 16.0),
                              decoration: BoxDecoration(
                                color: isCurrentLine ? const Color(0xFF094771) : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  if (isCurrentLine) ...[
                                    AnimatedScale(
                                      duration: const Duration(milliseconds: 200),
                                      scale: isCurrentLine ? 1.0 : 0.0,
                                      child: const Icon(Icons.play_arrow, color: Color(0xFFDCDCAA), size: 12),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Expanded(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'FiraCode',
                                        color: isCurrentLine ? const Color(0xFFDCDCAA) : const Color(0xFFCCCCCC),
                                        fontWeight: isCurrentLine ? FontWeight.w600 : FontWeight.w400,
                                        height: 1.2,
                                        fontFeatures: const [
                                          ui.FontFeature.enable('liga'),
                                          ui.FontFeature.enable('clig'),
                                          ui.FontFeature.enable('calt'),
                                        ],
                                      ),
                                      child: Text(line.trim()),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getIndentLevel(String line) {
    int spaces = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == ' ') {
        spaces++;
      } else {
        break;
      }
    }
    return spaces ~/ 4; // Assuming 4 spaces per indent level
  }
}
