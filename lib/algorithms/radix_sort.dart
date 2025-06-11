import 'dart:math' as math;

import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class RadixSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Radix Sort';

  @override
  String get description =>
      'Ordena por dígitos usando counting sort como subrutina. No basado en comparaciones. Complejidad: O(d×n) - Estable';

  @override
  String get timeComplexity => 'O(d×n)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Complejidad lineal O(d×n) para enteros',
    'No basado en comparaciones',
    'Algoritmo estable',
    'Eficiente para números con pocos dígitos',
    'Predecible en rendimiento',
  ];

  @override
  List<String> get disadvantages => [
    'Solo funciona con enteros no negativos',
    'Requiere memoria adicional O(n)',
    'Rendimiento depende del número de dígitos',
    'Menos eficiente para números muy grandes',
  ];

  @override
  List<String> get pseudocode => [
    'function radixSort(arr):',
    '    max = findMax(arr)',
    '    for exp = 1; max / exp > 0; exp *= 10:',
    '        countingSort(arr, exp)',
    '    return arr',
    '',
    'function countingSort(arr, exp):',
    '    count = [0] * 10',
    '    for i = 0 to length(arr) - 1:',
    '        digit = (arr[i] / exp) % 10',
    '        count[digit]++',
    '    for i = 1 to 9:',
    '        count[i] += count[i - 1]',
    '    for i = length(arr) - 1 down to 0:',
    '        digit = (arr[i] / exp) % 10',
    '        output[count[digit] - 1] = arr[i]',
    '        count[digit]--',
    '    copy output to arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(d×n) donde d es el número de dígitos del número más grande y n es el número de elementos. Para cada dígito, se realiza un counting sort que toma O(n) tiempo. Como d es típicamente pequeño y constante, se comporta como O(n) en la práctica.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(n) porque necesita un array auxiliar del mismo tamaño que el input para el counting sort, más un array de conteo de tamaño 10 (para los dígitos 0-9).';
  }

  @override
  String getStabilityExplanation() {
    return 'Es estable porque el counting sort subyacente es estable. Al procesar desde el último índice hacia atrás, se preserva el orden relativo de elementos con el mismo dígito en la posición actual.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Radix Sort: Ordenamiento por dígitos (LSD - Least Significant Digit)',
        currentPseudocodeLine: 0,
      ),
    );

    // Find the maximum number to know number of digits
    int max = arr.reduce(math.max);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🔍 Número máximo encontrado: $max (determina número de dígitos)',
        currentPseudocodeLine: 1,
      ),
    );

    // Do counting sort for every digit
    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      int digit = math.log(exp) ~/ math.log(10) + 1;
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔢 Procesando dígito $digit (posición $exp): Ordenando por dígito desde la derecha',
          currentPseudocodeLine: 2,
        ),
      );

      _countingSort(arr, exp);
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(arr.length, (index) => index),
        description: '🎉 ¡Radix Sort completado! Todos los dígitos procesados',
        currentPseudocodeLine: 4,
      ),
    );

    return _steps;
  }

  void _countingSort(List<int> arr, int exp) {
    int n = arr.length;
    List<int> output = List.filled(n, 0);
    List<int> count = List.filled(10, 0);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📊 Iniciando counting sort para dígito en posición $exp',
        currentPseudocodeLine: 6,
      ),
    );

    // Store count of occurrences in count[]
    for (int i = 0; i < n; i++) {
      int digit = (arr[i] ~/ exp) % 10;
      count[digit]++;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '🔢 arr[$i] = ${arr[i]}, dígito en posición $exp: $digit',
          currentPseudocodeLine: 8,
        ),
      );
    }

    _steps.add(SortStep(array: List.from(arr), description: '📈 Conteo de dígitos: $count', currentPseudocodeLine: 10));

    // Change count[i] so that count[i] now contains actual position of this digit in output[]
    for (int i = 1; i < 10; i++) {
      count[i] += count[i - 1];
    }

    _steps.add(
      SortStep(array: List.from(arr), description: '📐 Posiciones acumuladas: $count', currentPseudocodeLine: 11),
    );

    // Build the output array
    for (int i = n - 1; i >= 0; i--) {
      int digit = (arr[i] ~/ exp) % 10;
      output[count[digit] - 1] = arr[i];
      count[digit]--;

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [i],
          description: '📥 Colocando ${arr[i]} en posición ${count[digit]} (dígito $digit)',
          currentPseudocodeLine: 13,
        ),
      );
    }

    // Copy the output array to arr[], so that arr[] now contains sorted numbers according to current digit
    for (int i = 0; i < n; i++) {
      arr[i] = output[i];
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '✅ Counting sort completado para dígito en posición $exp',
        currentPseudocodeLine: 17,
      ),
    );
  }
}
