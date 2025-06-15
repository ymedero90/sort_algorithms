import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class BubbleSort extends SortingAlgorithm {
  @override
  String get name => 'Bubble Sort';

  @override
  String get description =>
      'Simple comparison-based algorithm that repeatedly steps through the list, '
      'compares adjacent elements and swaps them if they are in the wrong order.';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Simple implementation and easy to understand',
    'No additional memory space needed (in-place)',
    'Adaptive - performs better on nearly sorted data',
    'Stable - maintains relative order of equal elements',
    'Can detect if list is already sorted',
  ];

  @override
  List<String> get disadvantages => [
    'Poor time complexity O(n²) for all cases',
    'More swaps compared to other O(n²) algorithms',
    'Not practical for large datasets',
    'Inefficient for reverse-sorted arrays',
  ];

  @override
  List<String> get pseudocode => [
    'function bubbleSort(arr):',
    '    for i = 0 to n-1:',
    '        swapped = false',
    '        for j = 0 to n-i-2:',
    '            if arr[j] > arr[j+1]:',
    '                swap(arr[j], arr[j+1])',
    '                swapped = true',
    '        if not swapped: break',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() =>
      'Best case O(n) when array is already sorted with early termination. '
      'Average and worst case O(n²) due to nested loops comparing all pairs.';

  @override
  String getSpaceComplexityExplanation() =>
      'Only uses a constant amount of extra space for temporary variables, '
      'regardless of input size.';

  @override
  String getStabilityExplanation() =>
      'Stable because equal elements are never swapped, maintaining their '
      'relative order throughout the sorting process.';

  @override
  List<SortStep> sort(List<int> array) {
    List<SortStep> steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Starting Bubble Sort: We will make ${n - 1} passes through the array',
        currentPseudocodeLine: 0,
      ),
    );

    steps.add(
      SortStep(
        array: List.from(arr),
        description: '📋 Strategy: In each pass, the largest unsorted element will "bubble up" to its correct position',
        currentPseudocodeLine: 0,
      ),
    );

    for (int i = 0; i < n - 1; i++) {
      bool swapped = false;

      steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔄 PASS ${i + 1}: Looking for the largest element in positions [0..${n - 1 - i}]',
          currentPseudocodeLine: 1,
        ),
      );

      steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(i, (index) => n - 1 - index),
          description:
              '📊 Status: ${i == 0 ? 'No elements sorted yet' : 'Elements ${List.generate(i, (index) => n - 1 - index).map((idx) => arr[idx]).join(', ')} already in final position'}',
          currentPseudocodeLine: 1,
        ),
      );

      steps.add(
        SortStep(
          array: List.from(arr),
          description: '🏁 Goal: Find the largest element and move it to position ${n - 1 - i}',
          currentPseudocodeLine: 2,
        ),
      );

      steps.add(
        SortStep(
          array: List.from(arr),
          description: '📝 Initialize: swapped = false (will track if any swaps happen)',
          currentPseudocodeLine: 2,
        ),
      );

      for (int j = 0; j < n - i - 1; j++) {
        steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j, j + 1],
            sorted: List.generate(i, (index) => n - 1 - index),
            description: '👀 EXAMINE: Looking at adjacent pair - arr[$j]=${arr[j]} and arr[${j + 1}]=${arr[j + 1]}',
            currentPseudocodeLine: 4,
          ),
        );

        steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j, j + 1],
            sorted: List.generate(i, (index) => n - 1 - index),
            description: '❓ QUESTION: Is ${arr[j]} > ${arr[j + 1]}? Are they in wrong order?',
            currentPseudocodeLine: 4,
          ),
        );

        if (arr[j] > arr[j + 1]) {
          steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j, j + 1],
              sorted: List.generate(i, (index) => n - 1 - index),
              description: '❌ WRONG ORDER: ${arr[j]} > ${arr[j + 1]} - These need to be swapped!',
              currentPseudocodeLine: 5,
            ),
          );

          steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j, j + 1],
              sorted: List.generate(i, (index) => n - 1 - index),
              description: '🔄 SWAPPING: Exchanging arr[$j] and arr[${j + 1}]...',
              currentPseudocodeLine: 5,
            ),
          );

          // Perform swap
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          swapped = true;

          steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j, j + 1],
              sorted: List.generate(i, (index) => n - 1 - index),
              description: '✅ SWAPPED: Now arr[$j]=${arr[j]} and arr[${j + 1}]=${arr[j + 1]} - Order corrected!',
              currentPseudocodeLine: 6,
            ),
          );

          steps.add(
            SortStep(
              array: List.from(arr),
              description: '📝 MARK: swapped = true (we made at least one swap in this pass)',
              currentPseudocodeLine: 6,
            ),
          );
        } else {
          steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [j, j + 1],
              sorted: List.generate(i, (index) => n - 1 - index),
              description: '✅ CORRECT ORDER: ${arr[j]} ≤ ${arr[j + 1]} - No swap needed, continue',
              currentPseudocodeLine: 4,
            ),
          );
        }

        if (j < n - i - 2) {
          steps.add(
            SortStep(
              array: List.from(arr),
              description: '➡️ CONTINUE: Moving to next adjacent pair [${j + 1}, ${j + 2}]',
              currentPseudocodeLine: 3,
            ),
          );
        }
      }

      steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(i + 1, (index) => n - 1 - index),
          description:
              '🎯 PASS ${i + 1} COMPLETE: Largest element ${arr[n - 1 - i]} has bubbled to position ${n - 1 - i}',
          currentPseudocodeLine: 7,
        ),
      );

      // Check for early termination
      if (!swapped) {
        steps.add(
          SortStep(
            array: List.from(arr),
            description: '🔍 CHECKING: Did we make any swaps in this pass? swapped = $swapped',
            currentPseudocodeLine: 7,
          ),
        );

        steps.add(
          SortStep(
            array: List.from(arr),
            sorted: List.generate(n, (index) => index),
            description: '🎉 EARLY TERMINATION: No swaps made = array is already sorted! We can stop here.',
            currentPseudocodeLine: 7,
          ),
        );
        break;
      } else {
        steps.add(
          SortStep(
            array: List.from(arr),
            description: '📝 CHECKING: swapped = $swapped, so we need to continue with more passes',
            currentPseudocodeLine: 7,
          ),
        );
      }
    }

    // Final state - mark all as sorted
    if (steps.last.sorted.length != n) {
      steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(n, (index) => index),
          description: '🎉 BUBBLE SORT COMPLETE: All ${n - 1} passes finished - Array is fully sorted!',
          currentPseudocodeLine: 8,
        ),
      );
    }

    return steps;
  }
}
