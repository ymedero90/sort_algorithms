import 'dart:math' as math;

import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class CountingSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Counting Sort';

  @override
  String get description =>
      'Algoritmo no comparativo que cuenta ocurrencias de cada elemento. Eficiente para rangos pequeños. Complejidad: O(n+k) - Estable';

  @override
  String get timeComplexity => 'O(n+k)';

  @override
  String get spaceComplexity => 'O(k)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Complejidad lineal O(n+k) cuando k es pequeño',
    'Algoritmo estable',
    'No basado en comparaciones',
    'Predecible en rendimiento',
    'Útil como subrutina (ej: Radix Sort)',
  ];

  @override
  List<String> get disadvantages => [
    'Solo funciona con enteros en rango limitado',
    'Requiere memoria adicional O(k)',
    'Ineficiente si k >> n',
    'No funciona con datos negativos (sin modificación)',
  ];

  @override
  List<String> get pseudocode => [
    'function countingSort(arr):',
    '    max = findMax(arr)',
    '    count = array[0...max] = 0',
    '    for i = 0 to length(arr) - 1:',
    '        count[arr[i]]++',
    '    for i = 1 to max:',
    '        count[i] += count[i - 1]',
    '    for i = length(arr) - 1 down to 0:',
    '        output[count[arr[i]] - 1] = arr[i]',
    '        count[arr[i]]--',
    '    return output',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n+k) donde n es el número de elementos y k es el rango (max - min + 1). Tres pasadas lineales: contar elementos O(n), calcular posiciones O(k), y construir salida O(n). Total: O(n+k).';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(k) para el array de conteo donde k es el rango de valores, más O(n) para el array de salida. En total O(n+k).';
  }

  @override
  String getStabilityExplanation() {
    return 'Es estable porque procesa elementos desde el final hacia atrás, preservando el orden relativo de elementos iguales al usar las posiciones acumuladas del array de conteo.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    if (n == 0) return _steps;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Counting Sort: Algoritmo no comparativo basado en conteo',
        currentPseudocodeLine: 0,
      ),
    );

    // Find max element
    int max = arr.reduce(math.max);
    int min = arr.reduce(math.min);
    int range = max - min + 1;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🔍 Rango encontrado: min=$min, max=$max, range=$range',
        currentPseudocodeLine: 1,
      ),
    );

    // Create count array
    List<int> count = List.filled(range, 0);
    List<int> output = List.filled(n, 0);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📊 Inicializando array de conteo de tamaño $range',
        currentPseudocodeLine: 2,
      ),
    );

    // Count occurrences
    for (int i = 0; i < n; i++) {
      count[arr[i] - min]++;
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '📈 Contando arr[$i] = ${arr[i]}, count[${arr[i] - min}] = ${count[arr[i] - min]}',
          currentPseudocodeLine: 3,
        ),
      );
    }

    _steps.add(SortStep(array: List.from(arr), description: '📋 Conteo completado: $count', currentPseudocodeLine: 4));

    // Calculate cumulative count
    for (int i = 1; i < range; i++) {
      count[i] += count[i - 1];
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📐 Conteo acumulativo: $count (posiciones finales)',
        currentPseudocodeLine: 5,
      ),
    );

    // Build output array
    for (int i = n - 1; i >= 0; i--) {
      int value = arr[i];
      int pos = count[value - min] - 1;
      output[pos] = value;
      count[value - min]--;

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [i],
          description: '📥 Colocando ${arr[i]} en posición $pos del array resultado',
          currentPseudocodeLine: 7,
        ),
      );
    }

    // Copy back to original array
    for (int i = 0; i < n; i++) {
      arr[i] = output[i];
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡Counting Sort completado! Array ordenado por conteo',
        currentPseudocodeLine: 10,
      ),
    );

    return _steps;
  }
}
