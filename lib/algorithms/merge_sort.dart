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
        description: '🎯 Merge Sort: Starting divide-and-conquer process',
        currentPseudocodeLine: 0,
      ),
    );

    _mergeSort(arr, 0, arr.length - 1, 0);

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(arr.length, (index) => index),
        description: '🎉 Merge Sort completed! Array is fully sorted',
        currentPseudocodeLine: 6,
      ),
    );

    return _steps;
  }

  void _mergeSort(List<int> arr, int left, int right, int depth) {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(right - left + 1, (i) => left + i),
          description: '🔍 Analyzing range [$left..$right]: Can we divide this further?',
          currentPseudocodeLine: 1,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(right - left + 1, (i) => left + i),
          description: '📐 Calculating midpoint: mid = ($left + $right) ÷ 2 = $mid',
          currentPseudocodeLine: 2,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(mid - left + 1, (i) => left + i),
          description: '⬅️ DIVIDE: First half [$left..$mid] - Going deeper (depth ${depth + 1})',
          currentPseudocodeLine: 3,
        ),
      );

      _mergeSort(arr, left, mid, depth + 1);

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(right - mid, (i) => mid + 1 + i),
          description: '➡️ DIVIDE: Second half [${mid + 1}..$right] - Going deeper (depth ${depth + 1})',
          currentPseudocodeLine: 4,
        ),
      );

      _mergeSort(arr, mid + 1, right, depth + 1);

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(right - left + 1, (i) => left + i),
          description: '🔄 CONQUER: Both halves processed. Ready to merge [$left..$mid] with [${mid + 1}..$right]',
          currentPseudocodeLine: 5,
        ),
      );

      _merge(arr, left, mid, right);

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(right - left + 1, (i) => left + i),
          description: '✅ MERGE COMPLETE: Range [$left..$right] is now sorted and merged',
          currentPseudocodeLine: 5,
        ),
      );
    } else if (left == right) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [left],
          description: '🔍 Checking: Can we divide [$left..$right]? No, this is a single element.',
          currentPseudocodeLine: 1,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: [left],
          description: '✅ BASE CASE: Single element arr[$left] = ${arr[left]} is already sorted by definition',
          currentPseudocodeLine: 1,
        ),
      );
    }
  }

  void _merge(List<int> arr, int left, int mid, int right) {
    List<int> leftArr = arr.sublist(left, mid + 1);
    List<int> rightArr = arr.sublist(mid + 1, right + 1);

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: List.generate(mid - left + 1, (i) => left + i),
        description: '📋 STEP 1: Copying left half [$left..$mid] to temporary array',
        currentPseudocodeLine: 8,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: List.generate(right - mid, (i) => mid + 1 + i),
        description: '📋 STEP 2: Copying right half [${mid + 1}..$right] to temporary array',
        currentPseudocodeLine: 9,
      ),
    );

    int i = 0, j = 0, k = left;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 STEP 3: Temporary arrays created - Left: $leftArr, Right: $rightArr',
        currentPseudocodeLine: 10,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 STEP 4: Initialize pointers - i=0 (left), j=0 (right), k=$k (merge position)',
        currentPseudocodeLine: 10,
      ),
    );

    while (i < leftArr.length && j < rightArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description:
              '🔍 STEP: Both arrays have elements. Comparing leftArr[$i]=${leftArr[i]} vs rightArr[$j]=${rightArr[j]}',
          currentPseudocodeLine: 11,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '❓ DECISION: Which is smaller? ${leftArr[i]} or ${rightArr[j]}?',
          currentPseudocodeLine: 12,
        ),
      );

      if (leftArr[i] <= rightArr[j]) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '⬅️ CHOICE: ${leftArr[i]} ≤ ${rightArr[j]}, so take from LEFT array',
            currentPseudocodeLine: 12,
          ),
        );

        arr[k] = leftArr[i];

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '📥 PLACED: arr[$k] = ${arr[k]} (from left array, advance i: $i → ${i + 1})',
            currentPseudocodeLine: 13,
          ),
        );

        i++;
      } else {
        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '➡️ CHOICE: ${rightArr[j]} < ${leftArr[i]}, so take from RIGHT array',
            currentPseudocodeLine: 14,
          ),
        );

        arr[k] = rightArr[j];

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [k],
            description: '📥 PLACED: arr[$k] = ${arr[k]} (from right array, advance j: $j → ${j + 1})',
            currentPseudocodeLine: 15,
          ),
        );

        j++;
      }

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '➡️ ADVANCE: Move to next position k: $k → ${k + 1}',
          currentPseudocodeLine: 16,
        ),
      );

      k++;
    }

    // Handle remaining elements with detailed steps
    if (i < leftArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📋 REMAINING: Right array exhausted. Copying remaining left elements...',
          currentPseudocodeLine: 17,
        ),
      );
    }

    while (i < leftArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '⬅️ COPYING: Taking remaining leftArr[$i] = ${leftArr[i]}',
          currentPseudocodeLine: 17,
        ),
      );

      arr[k] = leftArr[i];

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [k],
          description: '📥 PLACED: arr[$k] = ${arr[k]} (remaining from left)',
          currentPseudocodeLine: 17,
        ),
      );

      i++;
      k++;
    }

    if (j < rightArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📋 REMAINING: Left array exhausted. Copying remaining right elements...',
          currentPseudocodeLine: 17,
        ),
      );
    }

    while (j < rightArr.length) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [k],
          description: '➡️ COPYING: Taking remaining rightArr[$j] = ${rightArr[j]}',
          currentPseudocodeLine: 17,
        ),
      );

      arr[k] = rightArr[j];

      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [k],
          description: '📥 PLACED: arr[$k] = ${arr[k]} (remaining from right)',
          currentPseudocodeLine: 17,
        ),
      );

      j++;
      k++;
    }
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
