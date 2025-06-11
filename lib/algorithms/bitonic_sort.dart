import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class BitonicSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Bitonic Sort';

  @override
  String get description =>
      'Algoritmo de ordenamiento paralelo que trabaja con secuencias bitónicas. Requiere potencia de 2. Complejidad: O(n log² n) - No estable';

  @override
  String get timeComplexity => 'O(n log² n)';

  @override
  String get spaceComplexity => 'O(log n)';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Altamente paralelizable',
    'Patrón de acceso a memoria predecible',
    'Ideal para hardware paralelo (GPU)',
    'Complejidad consistente O(n log² n)',
    'Network de comparación fija',
  ];

  @override
  List<String> get disadvantages => [
    'Solo funciona con arrays de tamaño 2^k',
    'Peor complejidad que algoritmos O(n log n)',
    'No es estable',
    'Complejo de entender e implementar',
    'Overhead para casos secuenciales',
  ];

  @override
  List<String> get pseudocode => [
    'function bitonicSort(arr, up):',
    '    if length(arr) > 1:',
    '        mid = length(arr) / 2',
    '        bitonicSort(arr[0...mid], true)',
    '        bitonicSort(arr[mid...end], false)',
    '        bitonicMerge(arr, up)',
    '',
    'function bitonicMerge(arr, up):',
    '    if length(arr) > 1:',
    '        k = length(arr) / 2',
    '        for i = 0 to k - 1:',
    '            if (arr[i] > arr[i + k]) == up:',
    '                swap(arr[i], arr[i + k])',
    '        bitonicMerge(arr[0...k], up)',
    '        bitonicMerge(arr[k...end], up)',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n log² n) porque hay log n niveles de recursión para crear la secuencia bitónica, y cada nivel requiere log n pasos de comparación-intercambio. Total: log n × log n = log² n niveles, cada uno con n/2 comparaciones.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(log n) para la pila de llamadas recursivas, ya que la profundidad máxima de recursión es log n (donde n es el tamaño del array).';
  }

  @override
  String getStabilityExplanation() {
    return 'No es estable porque realiza intercambios de elementos no adyacentes basados solo en comparaciones de valores, sin considerar el orden relativo original de elementos iguales.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    // Pad array to nearest power of 2 if necessary
    int powerOfTwo = 1;
    while (powerOfTwo < n) {
      powerOfTwo *= 2;
    }

    if (powerOfTwo != n) {
      // Pad with maximum values
      int maxVal = arr.isNotEmpty ? arr.reduce((a, b) => a > b ? a : b) : 0;
      while (arr.length < powerOfTwo) {
        arr.add(maxVal + 1);
      }

      _steps.add(
        SortStep(
          array: List.from(arr.take(n)),
          description: '⚡ Bitonic Sort requiere potencia de 2. Expandiendo array a tamaño $powerOfTwo',
          currentPseudocodeLine: 0,
        ),
      );
    }

    _steps.add(
      SortStep(
        array: List.from(arr.take(n)),
        description: '🎯 Bitonic Sort: Construyendo secuencia bitónica y ordenando',
        currentPseudocodeLine: 0,
      ),
    );

    _bitonicSort(arr, 0, arr.length, true);

    // Remove padding
    arr = arr.take(n).toList();

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡Bitonic Sort completado! Secuencia bitónica procesada',
        currentPseudocodeLine: 14,
      ),
    );

    return _steps;
  }

  void _bitonicSort(List<int> arr, int low, int cnt, bool up) {
    if (cnt > 1) {
      int mid = cnt ~/ 2;

      _steps.add(
        SortStep(
          array: List.from(arr.take(_steps.isEmpty ? arr.length : _steps.first.array.length)),
          comparing: List.generate(cnt, (i) => low + i),
          description:
              '🔧 Dividiendo secuencia [$low, ${low + cnt - 1}] - Primera mitad: ${up ? "ascendente" : "descendente"}',
          currentPseudocodeLine: 1,
        ),
      );

      // Sort first half in ascending order
      _bitonicSort(arr, low, mid, true);

      // Sort second half in descending order
      _bitonicSort(arr, low + mid, mid, false);

      _steps.add(
        SortStep(
          array: List.from(arr.take(_steps.first.array.length)),
          comparing: List.generate(cnt, (i) => low + i),
          description:
              '🔀 Fusionando secuencia bitónica [$low, ${low + cnt - 1}] en orden ${up ? "ascendente" : "descendente"}',
          currentPseudocodeLine: 5,
        ),
      );

      // Merge the whole sequence in the specified order
      _bitonicMerge(arr, low, cnt, up);
    }
  }

  void _bitonicMerge(List<int> arr, int low, int cnt, bool up) {
    if (cnt > 1) {
      int k = cnt ~/ 2;

      _steps.add(
        SortStep(
          array: List.from(arr.take(_steps.first.array.length)),
          description: '🔍 Bitonic merge: comparando elementos distancia $k en [$low, ${low + cnt - 1}]',
          currentPseudocodeLine: 7,
        ),
      );

      for (int i = low; i < low + k; i++) {
        bool shouldSwap = (arr[i] > arr[i + k]) == up;

        _steps.add(
          SortStep(
            array: List.from(arr.take(_steps.first.array.length)),
            comparing: [i, i + k],
            description: '🔍 Comparando arr[$i]=${arr[i]} con arr[${i + k}]=${arr[i + k]}',
            currentPseudocodeLine: 10,
          ),
        );

        if (shouldSwap) {
          int temp = arr[i];
          arr[i] = arr[i + k];
          arr[i + k] = temp;

          _steps.add(
            SortStep(
              array: List.from(arr.take(_steps.first.array.length)),
              swapping: [i, i + k],
              description: '🔄 Intercambiando arr[$i] y arr[${i + k}] (dirección ${up ? "ascendente" : "descendente"})',
              currentPseudocodeLine: 12,
            ),
          );
        }
      }

      // Recursively merge both halves
      _bitonicMerge(arr, low, k, up);
      _bitonicMerge(arr, low + k, k, up);
    }
  }
}
