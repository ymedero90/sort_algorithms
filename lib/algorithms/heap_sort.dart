import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class HeapSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Heap Sort';

  @override
  String get description =>
      'Utiliza una estructura de heap para ordenar. Divide en construcción de heap y extracción. Complejidad: O(n log n) - No estable';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Complejidad O(n log n) garantizada en todos los casos',
    'In-place (no requiere memoria extra)',
    'No tiene peor caso O(n²) como Quick Sort',
    'Útil cuando la memoria es limitada',
  ];

  @override
  List<String> get disadvantages => [
    'No es estable',
    'Constantes ocultas más altas que Quick Sort',
    'No es adaptivo',
    'Acceso a memoria no secuencial (cache-unfriendly)',
  ];

  @override
  List<String> get pseudocode => [
    'function heapSort(arr):',
    '    buildMaxHeap(arr)',
    '    for i = length(arr) - 1 down to 1:',
    '        swap(arr[0], arr[i])',
    '        heapify(arr, 0, i)',
    '',
    'function buildMaxHeap(arr):',
    '    for i = (length(arr) / 2) - 1 down to 0:',
    '        heapify(arr, i, length(arr))',
    '',
    'function heapify(arr, root, size):',
    '    largest = root',
    '    left = 2 * root + 1',
    '    right = 2 * root + 2',
    '    if left < size and arr[left] > arr[largest]:',
    '        largest = left',
    '    if right < size and arr[right] > arr[largest]:',
    '        largest = right',
    '    if largest != root:',
    '        swap(arr[root], arr[largest])',
    '        heapify(arr, largest, size)',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n log n) en todos los casos. La construcción del heap toma O(n) tiempo, y luego extraemos n elementos, cada extracción toma O(log n) para restaurar la propiedad del heap. Total: O(n) + n × O(log n) = O(n log n).';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) porque el algoritmo ordena in-place usando el mismo array para representar el heap. Solo utiliza variables auxiliares para índices y valores temporales.';
  }

  @override
  String getStabilityExplanation() {
    return 'No es estable porque durante la construcción del heap y las operaciones de heapify, elementos iguales pueden intercambiar posiciones, alterando su orden relativo original.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Heap Sort: Construcción de heap y extracción ordenada',
        currentPseudocodeLine: 0,
      ),
    );

    // Build max heap
    _buildMaxHeap(arr, n);

    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [0, i],
          description: '🔄 Extrayendo máximo: Intercambiando arr[0] = ${arr[0]} con arr[$i] = ${arr[i]}',
          currentPseudocodeLine: 2,
        ),
      );

      // Move current root to end
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [0, i],
          sorted: List.generate(n - i, (index) => n - 1 - index),
          description: '✅ Elemento ${arr[i]} colocado en posición final',
          currentPseudocodeLine: 3,
        ),
      );

      // Call heapify on the reduced heap
      _heapify(arr, 0, i);
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡Heap Sort completado! Todos los elementos extraídos del heap',
        currentPseudocodeLine: 4,
      ),
    );

    return _steps;
  }

  void _buildMaxHeap(List<int> arr, int n) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🏗️ Construyendo max heap desde abajo hacia arriba',
        currentPseudocodeLine: 6,
      ),
    );

    // Start from the last non-leaf node and heapify each node
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '🔧 Heapificando desde nodo $i (padre de ${2 * i + 1})',
          currentPseudocodeLine: 7,
        ),
      );
      _heapify(arr, i, n);
    }
  }

  void _heapify(List<int> arr, int root, int size) {
    int largest = root;
    int left = 2 * root + 1;
    int right = 2 * root + 2;

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: [root],
        description: '🔍 Heapify desde nodo $root: buscando el mayor entre nodo y sus hijos',
        currentPseudocodeLine: 10,
      ),
    );

    // If left child is larger than root
    if (left < size && arr[left] > arr[largest]) {
      largest = left;
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [left, root],
          description: '👈 Hijo izquierdo arr[$left] = ${arr[left]} > arr[$root] = ${arr[root]}',
          currentPseudocodeLine: 14,
        ),
      );
    }

    // If right child is larger than largest so far
    if (right < size && arr[right] > arr[largest]) {
      largest = right;
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [right, largest == left ? left : root],
          description: '👉 Hijo derecho arr[$right] = ${arr[right]} es el mayor',
          currentPseudocodeLine: 16,
        ),
      );
    }

    // If largest is not root
    if (largest != root) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [root, largest],
          description: '🔄 Intercambiando arr[$root] = ${arr[root]} con arr[$largest] = ${arr[largest]}',
          currentPseudocodeLine: 18,
        ),
      );

      int temp = arr[root];
      arr[root] = arr[largest];
      arr[largest] = temp;

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '♻️ Recursivamente heapificando subárbol afectado desde $largest',
          currentPseudocodeLine: 19,
        ),
      );

      // Recursively heapify the affected sub-tree
      _heapify(arr, largest, size);
    }
  }
}
