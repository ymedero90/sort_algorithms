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
        description: '🎯 Quick Sort: Divide-and-conquer with pivot partitioning',
        currentPseudocodeLine: 0,
      ),
    );

    _quickSort(arr, 0, arr.length - 1);

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(arr.length, (index) => index),
        description: '🎉 Quick Sort completed! All subarrays have been partitioned and sorted',
        currentPseudocodeLine: 5,
      ),
    );

    return _steps;
  }

  void _quickSort(List<int> arr, int low, int high) {
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🔄 QuickSort called for range [$low, $high]',
        currentPseudocodeLine: 1,
      ),
    );

    if (low < high) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📍 Partitioning range [$low, $high] with pivot ${arr[high]}',
          currentPseudocodeLine: 2,
        ),
      );

      int pi = _partition(arr, low, high);

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: [pi],
          description: '📍 Pivot in final position: pi = $pi. Dividing into subarrays',
          currentPseudocodeLine: 3,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔄 Recursively sorting left subarray [$low, ${pi - 1}]',
          currentPseudocodeLine: 3,
        ),
      );

      _quickSort(arr, low, pi - 1);
      _quickSort(arr, pi + 1, high);
    }
  }

  int _partition(List<int> arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1; // Definir la variable i

    _steps.add(
      SortStep(
        array: List.from(arr),
        comparing: [high],
        description: '📍 Pivot selected: arr[$high] = ${arr[high]}',
        currentPseudocodeLine: 6,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📝 Initializing i = ${low - 1} (index of smaller element)',
        currentPseudocodeLine: 7,
      ),
    );

    for (int j = low; j < high; j++) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [j, high],
          description: '🔍 Comparing arr[$j] = ${arr[j]} with pivot ${arr[high]}',
          currentPseudocodeLine: 8,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [j, high],
          description: '❓ Checking condition: arr[$j] = ${arr[j]} <= pivot $pivot',
          currentPseudocodeLine: 10,
        ),
      );

      if (arr[j] <= pivot) {
        i++;
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [i, j],
            description: '✅ ${arr[j]} ≤ $pivot: Incrementing i to $i',
            currentPseudocodeLine: 11,
          ),
        );

        if (i != j) {
          int temp = arr[i];
          arr[i] = arr[j];
          arr[j] = temp;

          _steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [i, j],
              description: '🔄 Element ${arr[i]} ≤ pivot, swapping with position $i',
              currentPseudocodeLine: 12,
            ),
          );
        }
      }
    }

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    _steps.add(
      SortStep(
        array: List.from(arr),
        swapping: [i + 1, high],
        description: '🎯 Placing pivot ${arr[high]} in correct position ${i + 1}',
        currentPseudocodeLine: 10,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: [i + 1],
        description: '✅ Partition complete: Pivot ${arr[i + 1]} is in final position ${i + 1}',
        currentPseudocodeLine: 11,
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
