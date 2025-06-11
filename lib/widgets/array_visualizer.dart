import 'package:flutter/material.dart';

import '../models/sort_step.dart';

class ArrayVisualizer extends StatefulWidget {
  final SortStep step;
  final AnimationController animationController;

  const ArrayVisualizer({super.key, required this.step, required this.animationController});

  @override
  State<ArrayVisualizer> createState() => _ArrayVisualizerState();
}

class _ArrayVisualizerState extends State<ArrayVisualizer> with TickerProviderStateMixin {
  late Animation<double> _pulseAnimation;
  List<int> _previousActiveElements = [];
  final List<String> _actionHistory = []; // Historial de acciones

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
      // Limpiar historial si:
      // 1. Es el paso inicial (contiene "Array inicial generado")
      // 2. O si es el primer paso de un algoritmo (currentPseudocodeLine == 0 y no es paso inicial)
      if (widget.step.description.contains('Array inicial generado') ||
          (widget.step.currentPseudocodeLine == 0 &&
              !widget.step.description.contains('Array inicial generado') &&
              _actionHistory.isNotEmpty)) {
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
  }

  void _updateActionHistory() {
    // Agregar la nueva descripción al historial sin límite
    if (widget.step.description.isNotEmpty &&
        (_actionHistory.isEmpty || _actionHistory.last != widget.step.description)) {
      setState(() {
        _actionHistory.add(widget.step.description);
        // Eliminamos la limitación del historial
      });
    }
  }

  Color _getBarColor(int index) {
    // Prioridad: ordenado primero, luego intercambio, luego comparación
    if (widget.step.sorted.contains(index)) {
      return const Color(0xFF4EC9B0); // VSCode green - SIEMPRE verde si está ordenado
    } else if (widget.step.swapping.contains(index)) {
      return const Color(0xFFF44747); // VSCode red
    } else if (widget.step.comparing.contains(index)) {
      return const Color(0xFFDCDCAA); // VSCode yellow
    }
    return const Color(0xFF569CD6); // VSCode blue
  }

  bool _isActiveElement(int index) {
    // Solo considerar activo si NO está ordenado y está en swapping o comparing
    if (widget.step.sorted.contains(index)) {
      return false; // Los elementos ordenados no son "activos"
    }
    return widget.step.swapping.contains(index) || widget.step.comparing.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Action history panel - reemplaza la descripción única
          Container(
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 140),
            padding: const EdgeInsets.all(16),
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
                    const Text(
                      'Action History',
                      style: TextStyle(color: Color(0xFF858585), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      '${_actionHistory.length} actions',
                      style: const TextStyle(color: Color(0xFF858585), fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Lista de acciones con scroll
                Expanded(
                  child:
                      _actionHistory.isEmpty
                          ? const Center(
                            child: Text(
                              'Start to see history...',
                              style: TextStyle(color: Color(0xFF858585), fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          )
                          : ListView.builder(
                            reverse: true, // Mostrar las más recientes arriba
                            itemCount: _actionHistory.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _actionHistory.length - 1 - index;
                              final action = _actionHistory[reversedIndex];
                              final isLatest = reversedIndex == _actionHistory.length - 1;

                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200 + (index * 50)),
                                curve: Curves.easeOut,
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isLatest ? const Color(0xFF007ACC).withOpacity(0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: isLatest ? Border.all(color: const Color(0xFF007ACC).withOpacity(0.3)) : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Indicador de tiempo/orden
                                    Container(
                                      width: 20,
                                      height: 16,
                                      margin: const EdgeInsets.only(top: 1),
                                      decoration: BoxDecoration(
                                        color:
                                            isLatest
                                                ? const Color(0xFF007ACC)
                                                : const Color(0xFF858585).withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${reversedIndex + 1}',
                                          style: TextStyle(
                                            color: isLatest ? Colors.white : const Color(0xFF858585),
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // Texto de la acción
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          color: isLatest ? const Color(0xFFCCCCCC) : const Color(0xFF858585),
                                          fontSize: isLatest ? 12 : 11,
                                          fontWeight: isLatest ? FontWeight.w500 : FontWeight.normal,
                                          height: 1.2,
                                        ),
                                        child: Text(action, maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ),
                                    ),

                                    // Indicador de acción actual
                                    if (isLatest) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 6,
                                        height: 6,
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

          const SizedBox(height: 24),

          // Array visualization (sin cambios)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final arrayLength = widget.step.array.length;
                final isCompact = arrayLength > 15;

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
                                animation: _pulseAnimation, // Sin escala, solo usar el pulso existente
                                builder: (context, child) {
                                  return SizedBox(
                                    width:
                                        isCompact
                                            ? (constraints.maxWidth / arrayLength * 0.8).clamp(8.0, 40.0)
                                            : (constraints.maxWidth / arrayLength * 0.9).clamp(20.0, 60.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Value label
                                        SizedBox(
                                          height: 24,
                                          child: Center(
                                            child: AnimatedDefaultTextStyle(
                                              duration: const Duration(milliseconds: 150),
                                              style: TextStyle(
                                                fontSize: isCompact ? 10 : 12,
                                                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                                                color: barColor,
                                              ),
                                              child: Text(value.toString()),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        // Simple animated bar without effects
                                        TweenAnimationBuilder<Color?>(
                                          duration: const Duration(milliseconds: 200),
                                          tween: ColorTween(begin: barColor, end: barColor),
                                          builder: (context, color, child) {
                                            return TweenAnimationBuilder<double>(
                                              duration: const Duration(milliseconds: 250),
                                              tween: Tween(end: height.clamp(20.0, double.infinity)),
                                              curve: Curves.easeOut,
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
                                                    borderRadius: BorderRadius.circular(4),
                                                    boxShadow:
                                                        isActive
                                                            ? [
                                                              BoxShadow(
                                                                color: effectiveColor.withOpacity(0.3),
                                                                blurRadius: 4,
                                                                spreadRadius: 1,
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
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  color: Colors.white.withOpacity(
                                                                    _pulseAnimation.value * 0.05,
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

                    const SizedBox(height: 16),

                    // Index labels with smooth transitions
                    SizedBox(
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            widget.step.array.asMap().entries.map((entry) {
                              final index = entry.key;
                              final isActive = _isActiveElement(index);
                              final isCompact = widget.step.array.length > 15;
                              final barColor = _getBarColor(index);

                              return SizedBox(
                                width:
                                    isCompact
                                        ? (constraints.maxWidth / widget.step.array.length * 0.8).clamp(8.0, 40.0)
                                        : (constraints.maxWidth / widget.step.array.length * 0.9).clamp(20.0, 60.0),
                                child: Center(
                                  child: TweenAnimationBuilder<Color?>(
                                    duration: const Duration(milliseconds: 150),
                                    tween: ColorTween(
                                      begin: isActive ? barColor.withOpacity(0.2) : Colors.transparent,
                                      end: isActive ? barColor.withOpacity(0.2) : Colors.transparent,
                                    ),
                                    builder: (context, backgroundColor, child) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 150),
                                          style: TextStyle(
                                            fontSize: isCompact ? 9 : 11,
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
