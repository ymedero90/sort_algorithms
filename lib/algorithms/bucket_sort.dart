import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class BucketSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Bucket Sort';

  @override
  String get description =>
      'Distribuye elementos en buckets y ordena cada uno individualmente. Eficiente para distribución uniforme. Complejidad: O(n+k) - Estable';

  @override
  String get timeComplexity => 'O(n+k)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Complejidad O(n+k) con distribución uniforme',
    'Algoritmo estable',
    'Paralelizable (buckets independientes)',
    'Funciona bien con números decimales',
    'Adaptable a diferentes distribuciones',
  ];

  @override
  List<String> get disadvantages => [
    'Rendimiento depende de la distribución',
    'Requiere conocimiento del rango de datos',
    'Memoria adicional O(n)',
    'Degrada a O(n²) con distribución sesgada',
  ];

  @override
  List<String> get pseudocode => [
    'function bucketSort(arr):',
    '    buckets = array of empty lists',
    '    for i = 0 to length(arr) - 1:',
    '        index = floor(arr[i] * bucketCount / maxValue)',
    '        buckets[index].add(arr[i])',
    '    for i = 0 to bucketCount - 1:',
    '        sort(buckets[i])',
    '    result = concatenate all buckets',
    '    return result',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n+k) en promedio cuando los elementos se distribuyen uniformemente entre k buckets. Cada bucket tiene aproximadamente n/k elementos, y ordenar cada bucket toma O((n/k)²). Con k buckets: k × O((n/k)²) = O(n²/k). Si k ≈ n, entonces O(n).';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(n) para almacenar todos los elementos en los buckets, más O(k) para los k buckets. En total O(n+k).';
  }

  @override
  String getStabilityExplanation() {
    return 'Es estable si el algoritmo usado para ordenar cada bucket individual es estable (como Insertion Sort), y se mantiene el orden de inserción en los buckets.';
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
        description: '🎯 Bucket Sort: Distribución en buckets y ordenamiento individual',
        currentPseudocodeLine: 0,
      ),
    );

    // Find max value for normalization
    int maxVal = arr.reduce((a, b) => a > b ? a : b);
    int minVal = arr.reduce((a, b) => a < b ? a : b);
    int bucketCount = (n / 2).ceil().clamp(1, 10); // Limit buckets for visualization

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🪣 Creando $bucketCount buckets para rango [$minVal, $maxVal]',
        currentPseudocodeLine: 1,
      ),
    );

    // Create buckets
    List<List<int>> buckets = List.generate(bucketCount, (_) => <int>[]);

    // Distribute elements into buckets
    for (int i = 0; i < n; i++) {
      int bucketIndex = ((arr[i] - minVal) * (bucketCount - 1) / (maxVal - minVal)).floor();
      bucketIndex = bucketIndex.clamp(0, bucketCount - 1);
      buckets[bucketIndex].add(arr[i]);

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '📥 Elemento ${arr[i]} → Bucket $bucketIndex',
          currentPseudocodeLine: 2,
        ),
      );
    }

    // Show bucket contents
    for (int i = 0; i < bucketCount; i++) {
      if (buckets[i].isNotEmpty) {
        _steps.add(
          SortStep(array: List.from(arr), description: '🪣 Bucket $i: ${buckets[i]}', currentPseudocodeLine: 4),
        );
      }
    }

    // Sort individual buckets and collect results
    List<int> result = [];
    for (int i = 0; i < bucketCount; i++) {
      if (buckets[i].isNotEmpty) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '🔧 Ordenando Bucket $i: ${buckets[i]}',
            currentPseudocodeLine: 5,
          ),
        );

        // Sort bucket using insertion sort
        _insertionSort(buckets[i]);

        _steps.add(
          SortStep(array: List.from(arr), description: '✅ Bucket $i ordenado: ${buckets[i]}', currentPseudocodeLine: 6),
        );

        result.addAll(buckets[i]);
      }
    }

    // Update original array
    for (int i = 0; i < n; i++) {
      arr[i] = result[i];
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 ¡Bucket Sort completado! Buckets concatenados',
        currentPseudocodeLine: 7,
      ),
    );

    return _steps;
  }

  void _insertionSort(List<int> bucket) {
    for (int i = 1; i < bucket.length; i++) {
      int key = bucket[i];
      int j = i - 1;
      while (j >= 0 && bucket[j] > key) {
        bucket[j + 1] = bucket[j];
        j--;
      }
      bucket[j + 1] = key;
    }
  }
}
