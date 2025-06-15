import '../algorithms/bitonic_sort.dart';
import '../algorithms/bubble_sort.dart';
import '../algorithms/bucket_sort.dart';
import '../algorithms/counting_sort.dart';
import '../algorithms/heap_sort.dart';
import '../algorithms/insertion_sort.dart';
import '../algorithms/merge_sort.dart';
import '../algorithms/quick_sort.dart';
import '../algorithms/radix_sort.dart';
import '../algorithms/selection_sort.dart';
import '../algorithms/shell_sort.dart';
import '../algorithms/tim_sort.dart';
import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class SortingService {
  static final List<SortingAlgorithm> algorithms = [
    BubbleSort(),
    SelectionSort(),
    InsertionSort(),
    ShellSort(),
    QuickSort(),
    MergeSort(),
    HeapSort(),
    TimSort(),
    CountingSort(),
    BucketSort(),
    RadixSort(),
    BitonicSort(),
  ];

  // Debug flag - set to false to disable debug logging
  static const bool _debugMode = false;

  static List<SortStep> executeAlgorithm(SortingAlgorithm algorithm, List<int> array) {
    if (_debugMode) {
      print('\n🚀 SortingService.executeAlgorithm()');
      print('📊 Algorithm: ${algorithm.name}');
      print('📊 Input array: $array');
    }

    final steps = algorithm.sort(array);

    if (_debugMode) {
      print('✅ Algorithm execution completed');
      print('📈 Generated ${steps.length} steps');
      print('🔍 First step: ${steps.isNotEmpty ? steps.first.description : 'No steps'}');
      print('🔍 Last step: ${steps.length > 1 ? steps.last.description : 'Only one step'}');
    }

    return steps;
  }
}
