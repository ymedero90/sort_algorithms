import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class QuickSort extends SortingAlgorithm {
  @override
  String get name => 'Quick Sort';

  @override
  String get description =>
      'Divide-and-conquer algorithm that partitions around a pivot element. Complexity: O(n log n) average - Unstable';

  @override
  String get timeComplexity => 'O(n log n) average, O(n²) worst case, Ω(n log n) best case';

  @override
  String get spaceComplexity => 'O(log n) for recursion';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Excellent average-case performance O(n log n)',
    'In-place sorting (requires minimal extra memory)',
    'Cache-efficient due to good locality of reference',
    'Widely used in practice (libraries and systems)',
    'Can be easily parallelized',
    'Simple to implement and understand',
  ];

  @override
  List<String> get disadvantages => [
    'Worst-case performance is O(n²)',
    'Not stable (changes relative order of equal elements)',
    'Performance depends heavily on pivot selection',
    'Degrades on already sorted or reverse sorted data',
    'Recursive implementation can cause stack overflow',
  ];

  @override
  List<String> get pseudocode => [
    'function quickSort(arr, low, high):',
    '    if low < high:',
    '        pi = partition(arr, low, high)',
    '        quickSort(arr, low, pi - 1)',
    '        quickSort(arr, pi + 1, high)',
    '',
    'function partition(arr, low, high):',
    '    pivot = arr[high]',
    '    i = low - 1',
    '    for j = low to high - 1:',
    '        if arr[j] <= pivot:',
    '            i = i + 1',
    '            swap(arr[i], arr[j])',
    '    swap(arr[i + 1], arr[high])',
    '    return i + 1',
  ];

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Quick Sort: Starting divide-and-conquer with pivot partitioning',
        currentPseudocodeLine: 0,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Strategy: Choose pivot, partition array, then recursively sort subarrays',
        currentPseudocodeLine: 0,
      ),
    );

    _quickSort(arr, 0, arr.length - 1, 0);

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(arr.length, (index) => index),
        description: '🎉 Quick Sort completed! All partitions have been sorted',
        currentPseudocodeLine: 5,
      ),
    );

    return _steps;
  }

  void _quickSort(List<int> arr, int low, int high, int depth) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: List.generate(high - low + 1, (i) => low + i),
        description: '🔍 ANALYZE: QuickSort called for range [$low..$high] (depth $depth)',
        currentPseudocodeLine: 1,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: List.generate(high - low + 1, (i) => low + i),
        description: '❓ CHECK: Is $low < $high? ${low < high ? "Yes - can partition" : "No - base case reached"}',
        currentPseudocodeLine: 1,
      ),
    );

    if (low < high) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(high - low + 1, (i) => low + i),
          description: '✅ CONDITION MET: Range has more than one element - proceeding to partition',
          currentPseudocodeLine: 2,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [high],
          description: '🎯 PARTITION START: Finding correct position for pivot in range [$low..$high]',
          currentPseudocodeLine: 2,
        ),
      );

      int pi = _partition(arr, low, high);

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: [pi],
          description: '✅ PARTITION COMPLETE: Pivot is now in final position $pi',
          currentPseudocodeLine: 2,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(pi - low, (i) => low + i),
          description: '⬅️ DIVIDE: Recursively sorting LEFT subarray [$low..${pi - 1}] (depth ${depth + 1})',
          currentPseudocodeLine: 3,
        ),
      );

      _quickSort(arr, low, pi - 1, depth + 1);

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(high - pi, (i) => pi + 1 + i),
          description: '➡️ DIVIDE: Recursively sorting RIGHT subarray [${pi + 1}..$high] (depth ${depth + 1})',
          currentPseudocodeLine: 4,
        ),
      );

      _quickSort(arr, pi + 1, high, depth + 1);

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔄 CONQUER: Both subarrays of range [$low..$high] are now sorted',
          currentPseudocodeLine: 5,
        ),
      );
    } else {
      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: low <= high ? [low] : [],
          description:
              '✅ BASE CASE: Range [$low..$high] has ${low == high ? "one element" : "no elements"} - already sorted',
          currentPseudocodeLine: 1,
        ),
      );
    }
  }

  int _partition(List<int> arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: [high],
        description: '📍 PIVOT SELECTION: Using last element arr[$high] = $pivot as pivot',
        currentPseudocodeLine: 7,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📝 INITIALIZE: i = ${low - 1} (index of last element smaller than pivot)',
        currentPseudocodeLine: 8,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 GOAL: Rearrange so elements ≤ $pivot are on left, elements > $pivot are on right',
        currentPseudocodeLine: 9,
      ),
    );

    for (int j = low; j < high; j++) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [j, high],
          description: '🔍 EXAMINE: arr[$j] = ${arr[j]} - comparing with pivot $pivot',
          currentPseudocodeLine: 10,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [j, high],
          description: '❓ QUESTION: Is ${arr[j]} ≤ $pivot?',
          currentPseudocodeLine: 10,
        ),
      );

      if (arr[j] <= pivot) {
        i++;
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [i, j],
            description: '✅ YES: ${arr[j]} ≤ $pivot - incrementing i to $i (expanding smaller section)',
            currentPseudocodeLine: 11,
          ),
        );

        if (i != j) {
          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [i, j],
              description: '🔄 SWAP NEEDED: Moving ${arr[j]} to position $i in smaller section',
              currentPseudocodeLine: 12,
            ),
          );

          int temp = arr[i];
          arr[i] = arr[j];
          arr[j] = temp;

          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [i, j],
              description: '✅ SWAPPED: arr[$i] = ${arr[i]}, arr[$j] = ${arr[j]}',
              currentPseudocodeLine: 12,
            ),
          );
        } else {
          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [i],
              description: '✓ NO SWAP: Element ${arr[j]} already in correct position $i',
              currentPseudocodeLine: 12,
            ),
          );
        }
      } else {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j],
            description: '❌ NO: ${arr[j]} > $pivot - leaving in greater section (no action needed)',
            currentPseudocodeLine: 10,
          ),
        );
      }

      if (j < high - 1) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '➡️ CONTINUE: Moving to next element j = ${j + 1}',
            currentPseudocodeLine: 9,
          ),
        );
      }
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🏁 SCAN COMPLETE: All elements examined, now placing pivot in final position',
        currentPseudocodeLine: 13,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        swapping: [i + 1, high],
        description: '🎯 FINAL SWAP: Moving pivot $pivot to position ${i + 1} (between smaller and larger elements)',
        currentPseudocodeLine: 13,
      ),
    );

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: [i + 1],
        description: '✅ PIVOT PLACED: ${arr[i + 1]} is now in its final sorted position ${i + 1}',
        currentPseudocodeLine: 14,
      ),
    );

    return i + 1;
  }

  @override
  String getTimeComplexityExplanation() {
    return 'Average case O(n log n): Each partition divides the array roughly in half, creating log n levels, and each level processes all n elements. Worst case O(n²): Occurs when pivot is always the smallest or largest element (e.g., sorted array with first/last pivot), creating n levels instead of log n. Best case O(n log n): When pivot always divides array exactly in half.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(log n) on average for the recursion stack, since we make log n recursive calls in a balanced partition. In worst case, it\'s O(n) when the recursion depth equals the array size. The partitioning itself is done in-place using O(1) extra space.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is not stable because the partitioning process can move equal elements across the pivot, changing their relative order. During partitioning, elements equal to the pivot may be placed on either side, and the final swap of the pivot can disrupt the original order of equal elements.';
  }

  List<SortStep> _steps = [];
}
