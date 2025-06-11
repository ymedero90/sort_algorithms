class SortStep {
  final List<int> array;
  final List<int> comparing;
  final List<int> swapping;
  final List<int> sorted;
  final String description;
  final int? currentPseudocodeLine; // New field for pseudocode highlighting

  SortStep({
    required this.array,
    this.comparing = const [],
    this.swapping = const [],
    this.sorted = const [],
    this.description = '',
    this.currentPseudocodeLine,
  });

  SortStep copyWith({
    List<int>? array,
    List<int>? comparing,
    List<int>? swapping,
    List<int>? sorted,
    String? description,
    int? currentPseudocodeLine,
  }) {
    return SortStep(
      array: array ?? List.from(this.array),
      comparing: comparing ?? this.comparing,
      swapping: swapping ?? this.swapping,
      sorted: sorted ?? this.sorted,
      description: description ?? this.description,
      currentPseudocodeLine: currentPseudocodeLine ?? this.currentPseudocodeLine,
    );
  }
}
