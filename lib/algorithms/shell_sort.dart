import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class ShellSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Shell Sort';

  @override
  String get description =>
      'Mejora de Insertion Sort usando secuencia de gaps. Reduce elementos distantes primero. Complejidad: O(n^1.5) - No estable';

  @override
  String get timeComplexity => 'O(n^1.5)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Mejor que O(n²) para arrays grandes',
    'In-place (no requiere memoria extra)',
    'Adaptivo para datos parcialmente ordenados',
    'Simple de implementar',
    'Buen rendimiento en la práctica',
  ];

  @override
  List<String> get disadvantages => [
    'No es estable',
    'Complejidad depende de la secuencia de gaps',
    'Análisis matemático complejo',
    'Peor que algoritmos O(n log n) avanzados',
  ];

  @override
  List<String> get pseudocode => [
    'function shellSort(arr):',
    '    gap = length(arr) / 2',
    '    while gap > 0:',
    '        for i = gap to length(arr) - 1:',
    '            temp = arr[i]',
    '            j = i',
    '            while j >= gap and arr[j - gap] > temp:',
    '                arr[j] = arr[j - gap]',
    '                j = j - gap',
    '            arr[j] = temp',
    '        gap = gap / 2',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n^1.5) en promedio con la secuencia de gaps clásica (n/2, n/4, ..., 1). La complejidad exacta depende de la secuencia de gaps utilizada. Con secuencias optimizadas puede llegar a O(n log² n), pero nunca mejor que O(n log n).';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) porque ordena in-place usando solo variables auxiliares constantes para índices, gaps y valores temporales.';
  }

  @override
  String getStabilityExplanation() {
    return 'No es estable porque puede intercambiar elementos no adyacentes que están separados por el gap, alterando el orden relativo de elementos iguales.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Shell Sort: Insertion Sort mejorado con secuencia de gaps',
        currentPseudocodeLine: 0,
      ),
    );

    int gap = n ~/ 2;

    while (gap > 0) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📏 Gap actual: $gap - Ordenando elementos separados por esta distancia',
          currentPseudocodeLine: 2,
        ),
      );

      for (int i = gap; i < n; i++) {
        int temp = arr[i];
        int j = i;

        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [i],
            description: '🔄 Elemento arr[$i] = $temp, buscando posición con gap $gap',
            currentPseudocodeLine: 3,
          ),
        );

        while (j >= gap && arr[j - gap] > temp) {
          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [j - gap, j],
              description: '🔍 Comparando arr[${j - gap}] = ${arr[j - gap]} > temp = $temp',
              currentPseudocodeLine: 6,
            ),
          );

          arr[j] = arr[j - gap];
          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j - gap, j],
              description: '➡️ Moviendo ${arr[j]} hacia adelante (gap $gap)',
              currentPseudocodeLine: 7,
            ),
          );

          j -= gap;
        }

        arr[j] = temp;
        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [j],
            description: '✅ Insertando $temp en posición $j',
            currentPseudocodeLine: 9,
          ),
        );
      }

      gap ~/= 2;
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📉 Reduciendo gap a ${gap > 0 ? gap : "terminado"}',
          currentPseudocodeLine: 10,
        ),
      );
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡Shell Sort completado! Todos los gaps procesados',
        currentPseudocodeLine: 11,
      ),
    );

    return _steps;
  }
}
