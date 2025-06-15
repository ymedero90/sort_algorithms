import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class ShellSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Shell Sort';

  @override
  String get description =>
      'Algoritmo de ordenamiento que utiliza una secuencia de gaps para ordenar elementos. Complejidad: O(n log² n) - Inestable';

  @override
  String get timeComplexity => 'O(n log² n)';

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
    return 'O(n log² n) en promedio con la secuencia de gaps clásica (n/2, n/4, ..., 1). La complejidad exacta depende de la secuencia de gaps utilizada. Con secuencias optimizadas puede llegar a O(n log n), pero nunca mejor que O(n log n).';
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
        description: '🎯 Shell Sort: Improved insertion sort using gap sequence',
        currentPseudocodeLine: 0,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Strategy: Sort elements at gap intervals, then reduce gap until gap = 1',
        currentPseudocodeLine: 1,
      ),
    );

    // Comenzar con un gran gap, luego reducir el gap
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📏 NEW GAP: Current gap = $gap - will sort elements separated by this distance',
          currentPseudocodeLine: 2,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🎯 GAP SORTING: Using insertion sort on gap-separated subsequences',
          currentPseudocodeLine: 3,
        ),
      );

      for (int i = gap; i < n; i++) {
        int temp = arr[i];
        int j = i;

        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [i],
            description: '🔄 ELEMENT: Taking arr[$i] = $temp to insert in gap-$gap sequence',
            currentPseudocodeLine: 4,
          ),
        );

        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [i],
            description: '📝 STORE: temp = arr[$i] = $temp (element to be positioned)',
            currentPseudocodeLine: 4,
          ),
        );

        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '📝 INITIALIZE: j = $i (starting position for comparison)',
            currentPseudocodeLine: 5,
          ),
        );

        bool firstComparison = true;

        while (j >= gap && arr[j - gap] > temp) {
          if (firstComparison) {
            _steps.add(
              SortStep(
                array: List.from(arr),
                comparing: [j - gap, i],
                description: '🔍 GAP COMPARE: arr[${j - gap}] = ${arr[j - gap]} > temp = $temp? (gap = $gap)',
                currentPseudocodeLine: 6,
              ),
            );
            firstComparison = false;
          } else {
            _steps.add(
              SortStep(
                array: List.from(arr),
                comparing: [j - gap, i],
                description: '🔍 CONTINUE: arr[${j - gap}] = ${arr[j - gap]} > temp = $temp? (gap = $gap)',
                currentPseudocodeLine: 6,
              ),
            );
          }

          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j - gap, j],
              description: '➡️ SHIFT: Moving ${arr[j - gap]} from position ${j - gap} to position $j (gap shift)',
              currentPseudocodeLine: 7,
            ),
          );

          arr[j] = arr[j - gap];

          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j],
              description: '✅ SHIFTED: arr[$j] = ${arr[j]} (made space for temp)',
              currentPseudocodeLine: 7,
            ),
          );

          j -= gap;
          _steps.add(
            SortStep(
              array: List.from(arr),
              description: '⬅️ MOVE BACK: j = $j (checking element $gap positions back)',
              currentPseudocodeLine: 8,
            ),
          );
        }

        if (j >= gap) {
          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [j - gap],
              description: '🔍 FOUND POSITION: arr[${j - gap}] = ${arr[j - gap]} ≤ temp = $temp',
              currentPseudocodeLine: 6,
            ),
          );
        } else {
          _steps.add(
            SortStep(
              array: List.from(arr),
              description: '🔍 BOUNDARY: Reached beginning of gap sequence',
              currentPseudocodeLine: 6,
            ),
          );
        }

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [j],
            description: '📍 INSERT: Placing temp = $temp at position $j in gap-$gap sequence',
            currentPseudocodeLine: 9,
          ),
        );

        arr[j] = temp;

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [j],
            description: '✅ PLACED: temp = $temp inserted at arr[$j] in gap-$gap sorted sequence',
            currentPseudocodeLine: 9,
          ),
        );
      }

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '✅ GAP COMPLETE: All gap-$gap subsequences are now sorted',
          currentPseudocodeLine: 10,
        ),
      );

      if (gap > 1) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '📉 REDUCE GAP: Next gap = ${gap ~/ 2} (halving the gap)',
            currentPseudocodeLine: 10,
          ),
        );
      }
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Shell Sort completed! Final gap-1 pass finished - array is fully sorted',
        currentPseudocodeLine: 11,
      ),
    );

    return _steps;
  }
}
