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
        description: '🎯 Heap Sort: Two phases - Build max heap, then extract elements',
        currentPseudocodeLine: 0,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Phase 1: Building max heap from unsorted array',
        currentPseudocodeLine: 1,
      ),
    );

    // Build max heap
    _buildMaxHeap(arr, n);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Phase 2: Extracting maximum elements one by one',
        currentPseudocodeLine: 2,
      ),
    );

    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [0, i],
          description: '🔄 EXTRACT: Maximum element arr[0] = ${arr[0]} goes to final position $i',
          currentPseudocodeLine: 3,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [0, i],
          description: '🔄 SWAP: Moving maximum ${arr[0]} to sorted section, bringing ${arr[i]} to root',
          currentPseudocodeLine: 3,
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
          description: '✅ PLACED: Element ${arr[i]} is now in final position $i',
          currentPseudocodeLine: 3,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [0],
          description: '🔧 RESTORE: Heap property violated - need to heapify from root with $i elements',
          currentPseudocodeLine: 4,
        ),
      );

      // Call heapify on the reduced heap
      _heapify(arr, 0, i);
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Heap Sort completed! All elements extracted from heap in descending order',
        currentPseudocodeLine: 5,
      ),
    );

    return _steps;
  }

  void _buildMaxHeap(List<int> arr, int n) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🏗️ BUILD HEAP: Starting from last non-leaf node and working upwards',
        currentPseudocodeLine: 6,
      ),
    );

    int lastNonLeaf = n ~/ 2 - 1;
    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: [lastNonLeaf],
        description: '📍 STARTING POINT: Last non-leaf node is at index $lastNonLeaf',
        currentPseudocodeLine: 7,
      ),
    );

    // Start from the last non-leaf node and heapify each node
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '🔧 HEAPIFY: Processing node $i - ensuring heap property for subtree rooted at $i',
          currentPseudocodeLine: 8,
        ),
      );
      _heapify(arr, i, n);

      if (i > 0) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '⬅️ MOVE UP: Moving to previous node ${i - 1}',
            currentPseudocodeLine: 8,
          ),
        );
      }
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '✅ MAX HEAP BUILT: Root contains maximum element ${arr[0]}',
        currentPseudocodeLine: 9,
      ),
    );
  }

  void _heapify(List<int> arr, int root, int size) {
    int largest = root;
    int left = 2 * root + 1;
    int right = 2 * root + 2;

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: [root],
        description:
            '🔍 HEAPIFY: Checking node $root (left: ${left < size ? left : "none"}, right: ${right < size ? right : "none"})',
        currentPseudocodeLine: 11,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📝 ASSUME: largest = $root (node ${arr[root]})',
        currentPseudocodeLine: 11,
      ),
    );

    // If left child is larger than root
    if (left < size) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [left, root],
          description: '👈 CHECK LEFT: arr[$left] = ${arr[left]} vs arr[$root] = ${arr[root]}',
          currentPseudocodeLine: 14,
        ),
      );

      if (arr[left] > arr[largest]) {
        largest = left;
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [left],
            description: '✅ LEFT WINS: ${arr[left]} > ${arr[root]} - left child is larger',
            currentPseudocodeLine: 15,
          ),
        );
      } else {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [root],
            description: '❌ ROOT WINS: ${arr[root]} ≥ ${arr[left]} - root remains largest',
            currentPseudocodeLine: 14,
          ),
        );
      }
    } else {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '❌ NO LEFT CHILD: Node $root has no left child',
          currentPseudocodeLine: 14,
        ),
      );
    }

    // If right child is larger than largest so far
    if (right < size) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [right, largest],
          description: '👉 CHECK RIGHT: arr[$right] = ${arr[right]} vs current largest = ${arr[largest]}',
          currentPseudocodeLine: 16,
        ),
      );

      if (arr[right] > arr[largest]) {
        largest = right;
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [right],
            description: '✅ RIGHT WINS: ${arr[right]} > ${arr[largest == left ? left : root]} - right child is largest',
            currentPseudocodeLine: 17,
          ),
        );
      } else {
        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '❌ CURRENT WINS: ${arr[largest]} ≥ ${arr[right]} - current largest remains',
            currentPseudocodeLine: 16,
          ),
        );
      }
    } else {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '❌ NO RIGHT CHILD: Node $root has no right child',
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
          description: '🔄 VIOLATION FOUND: Swapping arr[$root] = ${arr[root]} with arr[$largest] = ${arr[largest]}',
          currentPseudocodeLine: 19,
        ),
      );

      int temp = arr[root];
      arr[root] = arr[largest];
      arr[largest] = temp;

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [root, largest],
          description: '✅ SWAPPED: arr[$root] = ${arr[root]}, arr[$largest] = ${arr[largest]}',
          currentPseudocodeLine: 19,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [largest],
          description: '♻️ RECURSE: Check if subtree at $largest still satisfies heap property',
          currentPseudocodeLine: 20,
        ),
      );

      // Recursively heapify the affected sub-tree
      _heapify(arr, largest, size);
    } else {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [root],
          description: '✅ HEAP PROPERTY SATISFIED: Node $root is already largest in its subtree',
          currentPseudocodeLine: 18,
        ),
      );
    }
  }
}
