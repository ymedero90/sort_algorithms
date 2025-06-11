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

  static List<SortStep> executeAlgorithm(SortingAlgorithm algorithm, List<int> array) {
    return algorithm.sort(array);
  }
}
