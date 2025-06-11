import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class MergeSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Merge Sort';

  @override
  String get description =>
      'Stable divide-and-conquer algorithm that splits and merges arrays recursively. Complexity: O(n log n) - Stable';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Guaranteed O(n log n) performance in all cases',
    'Stable algorithm (maintains relative order)',
    'Predictable performance regardless of input',
    'Excellent for large datasets',
    'Naturally parallelizable',
    'Good for external sorting (large files)',
  ];

  @override
  List<String> get disadvantages => [
    'Requires O(n) additional memory space',
    'Slower than Quick Sort in practice for small arrays',
    'Not in-place (needs extra storage)',
    'Higher memory overhead',
    'Recursive implementation can cause stack overflow',
  ];

  @override
  List<String> get pseudocode => [
    'function mergeSort(arr, left, right):',
    '    if left < right:',
    '        mid = (left + right) / 2',
    '        mergeSort(arr, left, mid)',
    '        mergeSort(arr, mid + 1, right)',
    '        merge(arr, left, mid, right)',
    '',
    'function merge(arr, left, mid, right):',
    '    leftArr = arr[left...mid]',
    '    rightArr = arr[mid+1...right]',
    '    i = 0, j = 0, k = left',
    '    while i < len(leftArr) and j < len(rightArr):',
    '        if leftArr[i] <= rightArr[j]:',
    '            arr[k] = leftArr[i], i++',
    '        else:',
    '            arr[k] = rightArr[j], j++',
    '        k++',
    '    copy remaining elements',
  ];

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Merge Sort: Stable divide-and-conquer algorithm',
        currentPseudocodeLine: 0,
      ),
    );

    _mergeSort(arr, 0, arr.length - 1);

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(arr.length, (index) => index),
        description: '🎉 Merge Sort completed! All subarrays have been divided and merged',
        currentPseudocodeLine: 6,
      ),
    );

    return _steps;
  }

  void _mergeSort(List<int> arr, int left, int right) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🔄 MergeSort called for range [$left, $right]',
        currentPseudocodeLine: 1,
      ),
    );

    if (left < right) {
      int mid = (left + right) ~/ 2;

      _steps.add(
        SortStep(array: List.from(arr), description: '📊 Calculating middle: mid = $mid', currentPseudocodeLine: 2),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(mid - left + 1, (i) => left + i),
          description: '🔄 Recursively sorting left half [$left, $mid]',
          currentPseudocodeLine: 3,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(right - mid, (i) => mid + 1 + i),
          description: '🔄 Recursively sorting right half [${mid + 1}, $right]',
          currentPseudocodeLine: 4,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔀 Merging sorted halves [$left, $mid] and [${mid + 1}, $right]',
          currentPseudocodeLine: 5,
        ),
      );
      _merge(arr, left, mid, right);
    }
  }

  void _merge(List<int> arr, int left, int mid, int right) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: List.generate(right - left + 1, (i) => left + i),
        description: '🎯 Función merge: Fusionando subarrays [$left..$mid] y [${mid + 1}..$right]',
        currentPseudocodeLine: 7,
      ),
    );

    // Crear subarrays temporales
    List<int> leftArr = [];
    List<int> rightArr = [];

    for (int i = left; i <= mid; i++) {
      leftArr.add(arr[i]);
    }
    for (int i = mid + 1; i <= right; i++) {
      rightArr.add(arr[i]);
    }

    int n1 = leftArr.length;
    int n2 = rightArr.length;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Creating temporary arrays: left[$n1] and right[$n2]',
        currentPseudocodeLine: 7,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🔀 Merging: left=$leftArr and right=$rightArr',
        currentPseudocodeLine: 8,
      ),
    );

    int i = 0, j = 0, k = left;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📝 Inicializando índices: i=0, j=0, k=$left',
        currentPseudocodeLine: 10,
      ),
    );

    // Fusionar los subarrays de vuelta en arr[left..right]
    while (i < leftArr.length && j < rightArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '🔍 Comparing ${leftArr[i]} ≤ ${rightArr[j]}, placing ${arr[k]} at position $k',
          currentPseudocodeLine: 9,
        ),
      );

      if (leftArr[i] <= rightArr[j]) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [k],
            description: '✅ ${leftArr[i]} ≤ ${rightArr[j]}: Tomando elemento del subarray izquierdo',
            currentPseudocodeLine: 12,
          ),
        );

        arr[k] = leftArr[i];
        i++;

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '📥 arr[$k] = ${leftArr[i - 1]}, incrementando i a $i',
            currentPseudocodeLine: 13,
          ),
        );
      } else {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [k],
            description: '✅ ${leftArr[i]} > ${rightArr[j]}: Tomando elemento del subarray derecho',
            currentPseudocodeLine: 14,
          ),
        );

        arr[k] = rightArr[j];
        j++;

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '📥 arr[$k] = ${rightArr[j - 1]}, incrementando j a $j',
            currentPseudocodeLine: 15,
          ),
        );
      }

      k++;
      _steps.add(SortStep(array: List.from(arr), description: '📝 Incrementando k a $k', currentPseudocodeLine: 16));
    }

    // Copiar elementos restantes del subarray izquierdo
    while (i < leftArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '📥 Copying remaining left element: ${arr[k]} at position $k',
          currentPseudocodeLine: 10,
        ),
      );

      arr[k] = leftArr[i];
      i++;
      k++;
    }

    // Copiar elementos restantes del subarray derecho
    while (j < rightArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '📥 Copying remaining right element: ${arr[k]} at position $k',
          currentPseudocodeLine: 11,
        ),
      );

      arr[k] = rightArr[j];
      j++;
      k++;
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(right - left + 1, (i) => left + i),
        description: '✅ Merge complete for range [$left, $right]',
        currentPseudocodeLine: 12,
      ),
    );
  }

  @override
  String getTimeComplexityExplanation() {
    return 'O(n log n) in all cases (best, average, worst). The algorithm divides the array into halves recursively, creating log n levels. At each level, it performs O(n) work to merge all subarrays. Total: log n levels × O(n) work per level = O(n log n). This complexity is guaranteed regardless of input data.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(n) because it requires additional space to store temporary arrays during the merge process. At any point, we need space for the left and right subarrays being merged. Additionally, O(log n) space is needed for the recursion stack.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is stable because during the merge process, when two elements are equal, we always take the element from the left array first (leftArr[i] ≤ rightArr[j]). This ensures that equal elements maintain their relative order from the original array.';
  }
}
