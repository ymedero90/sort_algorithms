import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class TimSort extends SortingAlgorithm {
  List<SortStep> _steps = [];
  static const int RUN = 32; // Tamaño fijo de run como en la implementación estándar

  @override
  String get name => 'Tim Sort';

  @override
  String get description =>
      'Algoritmo híbrido adaptativo que combina Merge Sort e Insertion Sort. Usado en Python y Java. Complejidad: O(n log n) - Estable';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Excelente rendimiento en datos parcialmente ordenados',
    'Algoritmo estable',
    'Adaptativo (O(n) en el mejor caso)',
    'Usado en implementaciones reales (Python, Java)',
    'Optimizado para patrones comunes',
  ];

  @override
  List<String> get disadvantages => [
    'Implementación compleja',
    'Requiere memoria adicional O(n)',
    'Overhead para arrays muy pequeños',
    'Algoritmo sofisticado para casos simples',
  ];

  @override
  List<String> get pseudocode => [
    'function timSort(arr):',
    '    RUN = 32',
    '    for i = 0; i < len; i += RUN:',
    '        end = min(i + RUN - 1, len - 1)',
    '        insertionSort(arr, i, end)',
    '    size = RUN',
    '    while size < len:',
    '        for left = 0; left < len; left += 2 * size:',
    '            mid = left + size - 1',
    '            right = min(left + 2 * size - 1, len - 1)',
    '            if mid < right:',
    '                merge(arr, left, mid, right)',
    '        size = 2 * size',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n log n) en el peor caso, pero O(n) en el mejor caso cuando los datos están parcialmente ordenados. Identifica y aprovecha secuencias ya ordenadas (runs) para reducir el trabajo de fusión.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(n) para el array auxiliar usado en las operaciones de merge, similar a Merge Sort tradicional.';
  }

  @override
  String getStabilityExplanation() {
    return 'Es estable porque tanto Insertion Sort como Merge Sort son estables, y TimSort preserva cuidadosamente el orden relativo durante todas las operaciones.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    if (n <= 1) return _steps;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 TimSort: Algoritmo híbrido con RUN fijo de $RUN elementos',
        currentPseudocodeLine: 0,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📏 RUN = $RUN (tamaño fijo de subarray para Insertion Sort)',
        currentPseudocodeLine: 1,
      ),
    );

    // Sort individual subarrays of size RUN using insertion sort
    for (int i = 0; i < n; i += RUN) {
      int end = (i + RUN - 1 < n) ? i + RUN - 1 : n - 1;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(end - i + 1, (index) => i + index),
          description: '🔧 Insertion Sort en run [$i, $end] (tamaño ${end - i + 1})',
          currentPseudocodeLine: 2,
        ),
      );

      _insertionSort(arr, i, end);

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(end - i + 1, (index) => i + index),
          description: '✅ Run [$i, $end] ordenado con Insertion Sort',
          currentPseudocodeLine: 4,
        ),
      );
    }

    // Start merging from size RUN
    int size = RUN;
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📐 Iniciando fase de merge con size = $size',
        currentPseudocodeLine: 5,
      ),
    );

    while (size < n) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔀 Merge phase: fusionando runs de tamaño $size',
          currentPseudocodeLine: 6,
        ),
      );

      for (int left = 0; left < n; left += 2 * size) {
        int mid = left + size - 1;
        int right = (left + 2 * size - 1 < n - 1) ? left + 2 * size - 1 : n - 1;

        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '📍 Calculando posiciones: left=$left, mid=$mid, right=$right',
            currentPseudocodeLine: 8,
          ),
        );

        if (mid < right) {
          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: List.generate(right - left + 1, (i) => left + i),
              description: '🔀 Fusionando runs: [$left..$mid] con [${mid + 1}..$right]',
              currentPseudocodeLine: 10,
            ),
          );

          _merge(arr, left, mid, right);

          _steps.add(
            SortStep(
              array: List.from(arr),
              sorted: List.generate(right - left + 1, (i) => left + i),
              description: '✅ Merge completado: [$left..$right] (tamaño ${right - left + 1})',
              currentPseudocodeLine: 11,
            ),
          );
        }
      }

      size = 2 * size;
      _steps.add(
        SortStep(array: List.from(arr), description: '📈 Duplicando tamaño: size = $size', currentPseudocodeLine: 12),
      );
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡TimSort completado! Algoritmo híbrido exitoso',
        currentPseudocodeLine: 13,
      ),
    );

    return _steps;
  }

  void _insertionSort(List<int> arr, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
      int temp = arr[i];
      int j = i - 1;

      while (j >= left && arr[j] > temp) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = temp;
    }
  }

  void _merge(List<int> arr, int left, int mid, int right) {
    // Create temporary arrays for left and right subarrays
    int len1 = mid - left + 1;
    int len2 = right - mid;

    List<int> leftArr = [];
    List<int> rightArr = [];

    // Copy data to temporary arrays
    for (int i = 0; i < len1; i++) {
      leftArr.add(arr[left + i]);
    }
    for (int i = 0; i < len2; i++) {
      rightArr.add(arr[mid + 1 + i]);
    }

    // Merge the temporary arrays back into arr[left..right]
    int i = 0, j = 0, k = left;

    while (i < len1 && j < len2) {
      if (leftArr[i] <= rightArr[j]) {
        arr[k] = leftArr[i];
        i++;
      } else {
        arr[k] = rightArr[j];
        j++;
      }
      k++;
    }

    // Copy remaining elements of leftArr, if any
    while (i < len1) {
      arr[k] = leftArr[i];
      i++;
      k++;
    }

    // Copy remaining elements of rightArr, if any
    while (j < len2) {
      arr[k] = rightArr[j];
      j++;
      k++;
    }
  }
}
