import 'package:flutter/material.dart';

import '../models/sort_step.dart';

class ArrayVisualizer extends StatefulWidget {
  final SortStep step;
  final AnimationController animationController;
  final bool isMobile;

  const ArrayVisualizer({super.key, required this.step, required this.animationController, this.isMobile = false});

  @override
  State<ArrayVisualizer> createState() => _ArrayVisualizerState();
}

class _ArrayVisualizerState extends State<ArrayVisualizer> with TickerProviderStateMixin {
  late Animation<double> _pulseAnimation;
  List<int> _previousActiveElements = [];
  final List<String> _actionHistory = [];

  // Debug flag - set to false to disable debug logging
  static const bool _debugMode = false;

  @override
  void initState() {
    super.initState();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: widget.animationController, curve: Curves.easeInOut));

    _updateActiveElements();
    _updateActionHistory();
  }

  @override
  void didUpdateWidget(ArrayVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.step != widget.step) {
      if (_debugMode) {
        print('\n🎨 ArrayVisualizer: Step changed');
        print('📊 New step array: ${widget.step.array}');
        print('📝 New step description: ${widget.step.description}');
      }

      // Clear history if needed
      if (widget.step.description.contains('Array inicial generado') ||
          widget.step.description.contains('Initial array generated') ||
          (widget.step.currentPseudocodeLine == 0 &&
              !widget.step.description.contains('Array inicial generado') &&
              !widget.step.description.contains('Initial array generated') &&
              _actionHistory.isNotEmpty)) {
        if (_debugMode) print('🗑️ Clearing action history (new algorithm or initial step)');
        setState(() {
          _actionHistory.clear();
        });
      }

      _updateActiveElements();
      _updateActionHistory();
    }
  }

  void _updateActiveElements() {
    _previousActiveElements = [...widget.step.swapping, ...widget.step.comparing];
    if (_debugMode) print('🎯 Updated active elements: $_previousActiveElements');
  }

  void _updateActionHistory() {
    if (widget.step.description.isNotEmpty &&
        (_actionHistory.isEmpty || _actionHistory.last != widget.step.description)) {
      if (_debugMode) print('📝 Adding to history: ${widget.step.description}');
      setState(() {
        _actionHistory.add(widget.step.description);
      });
      if (_debugMode) print('📈 History now has ${_actionHistory.length} items');
    }
  }

  Color _getBarColor(int index) {
    if (widget.step.sorted.contains(index)) {
      return const Color(0xFF4EC9B0);
    } else if (widget.step.swapping.contains(index)) {
      return const Color(0xFFF44747);
    } else if (widget.step.comparing.contains(index)) {
      return const Color(0xFFDCDCAA);
    } else {
      return const Color(0xFF569CD6);
    }
  }

  bool _isActiveElement(int index) {
    if (widget.step.sorted.contains(index)) {
      return false;
    }
    return widget.step.swapping.contains(index) || widget.step.comparing.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.isMobile ? 12 : 20),
      child: Column(
        children: [
          // Action history panel - más compacto en móvil
          Container(
            constraints: BoxConstraints(minHeight: widget.isMobile ? 60 : 80, maxHeight: widget.isMobile ? 100 : 140),
            padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFF252526),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3C3C3C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del historial
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(color: const Color(0xFF007ACC), borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isMobile ? 'History' : 'Action History',
                      style: const TextStyle(color: Color(0xFF858585), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text('${_actionHistory.length}', style: const TextStyle(color: Color(0xFF858585), fontSize: 10)),
                  ],
                ),

                SizedBox(height: widget.isMobile ? 6 : 8),

                // Lista de acciones con scroll
                Expanded(
                  child:
                      _actionHistory.isEmpty
                          ? Center(
                            child: Text(
                              widget.isMobile ? 'Start...' : 'Start to see history...',
                              style: const TextStyle(
                                color: Color(0xFF858585),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                          : ListView.builder(
                            reverse: true,
                            itemCount: _actionHistory.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _actionHistory.length - 1 - index;
                              final action = _actionHistory[reversedIndex];
                              final isLatest = reversedIndex == _actionHistory.length - 1;

                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200 + (index * 50)),
                                curve: Curves.easeOut,
                                margin: EdgeInsets.only(bottom: widget.isMobile ? 2 : 4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.isMobile ? 6 : 8,
                                  vertical: widget.isMobile ? 2 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isLatest ? const Color(0xFF007ACC).withOpacity(0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: isLatest ? Border.all(color: const Color(0xFF007ACC).withOpacity(0.3)) : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!widget.isMobile) ...[
                                      // Indicador de tiempo/orden
                                      Container(
                                        width: 18,
                                        height: 14,
                                        margin: const EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                          color:
                                              isLatest
                                                  ? const Color(0xFF007ACC)
                                                  : const Color(0xFF858585).withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${reversedIndex + 1}',
                                            style: TextStyle(
                                              color: isLatest ? Colors.white : const Color(0xFF858585),
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],

                                    // Texto de la acción
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          color: isLatest ? const Color(0xFFCCCCCC) : const Color(0xFF858585),
                                          fontSize: widget.isMobile ? 10 : (isLatest ? 12 : 11),
                                          fontWeight: isLatest ? FontWeight.w500 : FontWeight.normal,
                                          height: 1.2,
                                        ),
                                        child: Text(
                                          action,
                                          maxLines: widget.isMobile ? 1 : 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),

                                    // Indicador de acción actual
                                    if (isLatest) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        width: widget.isMobile ? 4 : 6,
                                        height: widget.isMobile ? 4 : 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF4EC9B0),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),

          SizedBox(height: widget.isMobile ? 16 : 24),

          // Array visualization
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final arrayLength = widget.step.array.length;
                final isCompact = arrayLength > (widget.isMobile ? 10 : 15);

                return Column(
                  children: [
                    // Bar chart visualization
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:
                            widget.step.array.asMap().entries.map((entry) {
                              final index = entry.key;
                              final value = entry.value;
                              final maxValue = widget.step.array.reduce((a, b) => a > b ? a : b);
                              final height = (value / maxValue) * (constraints.maxHeight * 0.6);
                              final isActive = _isActiveElement(index);
                              final barColor = _getBarColor(index);

                              return AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  double barWidth;
                                  if (widget.isMobile) {
                                    barWidth =
                                        isCompact
                                            ? (constraints.maxWidth / arrayLength * 0.85).clamp(6.0, 25.0)
                                            : (constraints.maxWidth / arrayLength * 0.9).clamp(15.0, 35.0);
                                  } else {
                                    barWidth =
                                        isCompact
                                            ? (constraints.maxWidth / arrayLength * 0.8).clamp(8.0, 40.0)
                                            : (constraints.maxWidth / arrayLength * 0.9).clamp(20.0, 60.0);
                                  }

                                  return SizedBox(
                                    width: barWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Value label
                                        SizedBox(
                                          height: widget.isMobile ? 16 : 24,
                                          child: Center(
                                            child: AnimatedDefaultTextStyle(
                                              duration: const Duration(milliseconds: 150),
                                              style: TextStyle(
                                                fontSize:
                                                    widget.isMobile ? (isCompact ? 8 : 10) : (isCompact ? 10 : 12),
                                                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                                                color: barColor,
                                              ),
                                              child: Text(value.toString()),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: widget.isMobile ? 2 : 4),

                                        // Animated bar
                                        TweenAnimationBuilder<Color?>(
                                          duration: const Duration(milliseconds: 400),
                                          tween: ColorTween(begin: barColor, end: barColor),
                                          builder: (context, color, child) {
                                            return TweenAnimationBuilder<double>(
                                              duration: const Duration(milliseconds: 500),
                                              tween: Tween(end: height.clamp(15.0, double.infinity)),
                                              curve: Curves.easeInOut,
                                              builder: (context, animatedHeight, child) {
                                                final effectiveColor = color ?? barColor;

                                                return Container(
                                                  height: animatedHeight,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [effectiveColor, effectiveColor.withOpacity(0.7)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(widget.isMobile ? 2 : 4),
                                                    boxShadow:
                                                        isActive
                                                            ? [
                                                              BoxShadow(
                                                                color: effectiveColor.withOpacity(0.5),
                                                                blurRadius: widget.isMobile ? 4 : 6,
                                                                spreadRadius: widget.isMobile ? 1 : 2,
                                                              ),
                                                            ]
                                                            : null,
                                                  ),
                                                  child:
                                                      isActive
                                                          ? AnimatedBuilder(
                                                            animation: _pulseAnimation,
                                                            builder: (context, child) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(
                                                                    widget.isMobile ? 2 : 4,
                                                                  ),
                                                                  color: Colors.white.withOpacity(
                                                                    _pulseAnimation.value * 0.1,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                          : null,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: widget.isMobile ? 8 : 16),

                    // Index labels
                    SizedBox(
                      height: widget.isMobile ? 16 : 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            widget.step.array.asMap().entries.map((entry) {
                              final index = entry.key;
                              final isActive = _isActiveElement(index);
                              final isCompact = widget.step.array.length > (widget.isMobile ? 10 : 15);
                              final barColor = _getBarColor(index);

                              double indexWidth;
                              if (widget.isMobile) {
                                indexWidth =
                                    isCompact
                                        ? (constraints.maxWidth / widget.step.array.length * 0.85).clamp(6.0, 25.0)
                                        : (constraints.maxWidth / widget.step.array.length * 0.9).clamp(15.0, 35.0);
                              } else {
                                indexWidth =
                                    isCompact
                                        ? (constraints.maxWidth / widget.step.array.length * 0.8).clamp(8.0, 40.0)
                                        : (constraints.maxWidth / widget.step.array.length * 0.9).clamp(20.0, 60.0);
                              }

                              return SizedBox(
                                width: indexWidth,
                                child: Center(
                                  child: TweenAnimationBuilder<Color?>(
                                    duration: const Duration(milliseconds: 150),
                                    tween: ColorTween(
                                      begin: isActive ? barColor.withOpacity(0.2) : Colors.transparent,
                                      end: isActive ? barColor.withOpacity(0.2) : Colors.transparent,
                                    ),
                                    builder: (context, backgroundColor, child) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 2 : 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 150),
                                          style: TextStyle(
                                            fontSize: widget.isMobile ? (isCompact ? 7 : 9) : (isCompact ? 9 : 11),
                                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                            color: isActive ? barColor : const Color(0xFF858585),
                                          ),
                                          child: Text(index.toString(), textAlign: TextAlign.center),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
