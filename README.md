# Sorting Algorithms Visualizer

A beautiful, interactive Flutter application that visualizes various sorting algorithms with real-time step-by-step execution, pseudocode highlighting, and comprehensive algorithm information.

![VSCode-inspired dark theme interface](https://img.shields.io/badge/UI-VSCode%20Inspired-007ACC?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

## 🌟 Features

### 🎯 Interactive Visualization

- **Real-time array visualization** with color-coded elements
- **Step-by-step execution** with pause/resume functionality
- **Manual step navigation** with previous/next controls in status bar
- **Adjustable animation speed** (0.5x to 3.0x)
- **Responsive design** with collapsible panels

### 📊 Supported Algorithms

Based on the actual implementation, the app includes these algorithms:

- **Quick Sort** - Efficient divide-and-conquer algorithm
- **Bubble Sort** - Educational comparison-based sorting
- **Heap Sort** - In-place sorting using heap data structure
- **Merge Sort** - Stable divide-and-conquer approach
- **Insertion Sort** - Simple and efficient for small datasets
- **Selection Sort** - In-place comparison sorting
- **Radix Sort** - Non-comparative integer sorting
- **Shell Sort** - Improved insertion sort with gap sequences
- **Counting Sort** - Linear time sorting for limited range
- **Bucket Sort** - Distribution sorting for uniform data
- **Tim Sort** - Hybrid stable sorting implementation
- **Bitonic Sort** - Parallel-friendly comparison network

### 🎨 Visual Elements

- **Color-coded visualization**:
  - 🔵 Normal elements
  - 🟡 Elements being compared
  - 🔴 Elements being swapped
  - 🟢 Sorted elements
- **VSCode-inspired dark theme**
- **Smooth animations** with pulse effects during execution
- **Interactive legends** showing element states

### 📝 Educational Content

- **Real-time pseudocode highlighting** synchronized with visualization steps
- **Comprehensive algorithm information** including:
  - Time and space complexity analysis with detailed explanations
  - Stability characteristics
  - Advantages and disadvantages
  - Algorithm-specific implementation details and theory
- **Two-tab interface**: Visualization and Information tabs

### ⚙️ Configuration Options

- **Array size control** (3-64 elements with validation)
- **Algorithm selection** with dropdown menu
- **Speed adjustment** with slider (0.5x to 3.0x)
- **Collapsible panels** for Configuration, Visualization, and Pseudocode sections

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- VS Code or Android Studio (recommended)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/sorting_algorithms.git
   cd sorting_algorithms
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**

   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                 # Main application with complete UI
├── models/
│   ├── sort_step.dart        # Step model for visualization
│   └── sorting_algorithm.dart # Algorithm interface
├── services/
│   └── sorting_service.dart  # Algorithm execution service
├── algorithms/              # Individual algorithm implementations
└── widgets/
    ├── array_visualizer.dart # Main visualization widget
    └── pseudocode_viewer.dart # Pseudocode display widget
```

## 🎮 How to Use

### Basic Operations

1. **Select an algorithm** from the dropdown menu in Configuration panel
2. **Set array size** (3-64 elements) - values outside this range are auto-corrected
3. **Generate a new array** using the "New Array" button
4. **Start visualization** with the Start/Pause/Resume button
5. **Control playback** with the three action buttons (New Array, Start/Pause, Reset)
6. **Adjust speed** using the speed slider

### Interface Navigation

- **Configuration Panel**: Algorithm settings and controls (collapsible)
- **Visualization Tab**: Real-time array visualization and synchronized pseudocode
- **Information Tab**: Detailed algorithm analysis and educational content
- **Collapsible Panels**: Click chevron arrows to hide/show sections
- **Status Bar**: Current step counter and manual navigation controls

### Available Controls

- **New Array**: Generate a random array with current size setting
- **Start/Pause/Resume**: Control animation playback with state-aware button
- **Reset**: Return to initial state
- **Speed Slider**: Adjust animation speed in real-time
- **Step Navigation**: Previous/Next buttons in status bar
- **Panel Collapse**: Hide/show Configuration, Visualization, or Pseudocode panels

## 🏗️ Architecture

### Algorithm Interface

Each sorting algorithm implements the `SortingAlgorithm` abstract class:

```dart
abstract class SortingAlgorithm {
  String get name;
  String get description;
  String get timeComplexity;
  String get spaceComplexity;
  bool get isStable;
  List<String> get advantages;
  List<String> get disadvantages;
  List<String> get pseudocode;
  
  // Additional methods for detailed explanations
  String getTimeComplexityExplanation();
  String getSpaceComplexityExplanation();
  String getStabilityExplanation();
  
  List<SortStep> sort(List<int> array);
}
```

### Step-by-Step Execution

The `SortStep` model captures each state during sorting:

```dart
class SortStep {
  final List<int> array;
  final List<int> comparing;
  final List<int> swapping;
  final List<int> sorted;
  final String description;
  final int? currentPseudocodeLine;
}
```

## 🎨 Customization

### Adding New Algorithms

1. Create a new file in `lib/algorithms/`
2. Implement the `SortingAlgorithm` interface
3. Add the algorithm to `SortingService.algorithms` list
4. Include algorithm-specific information in the main UI's `_buildInformationTab()` method

### Theming

The application uses a VSCode-inspired color scheme:

- Background: `#1E1E1E`
- Surfaces: `#252526`
- Headers: `#2D2D30`
- Primary: `#007ACC`
- Text: `#CCCCCC`
- Secondary text: `#858585`

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-algorithm`)
3. Commit your changes (`git commit -am 'Add new sorting algorithm'`)
4. Push to the branch (`git push origin feature/new-algorithm`)
5. Create a Pull Request

### Contribution Guidelines

- Follow Dart/Flutter coding standards
- Add comprehensive documentation for new algorithms
- Include detailed complexity explanations
- Ensure UI consistency with existing VSCode-inspired design

## 📊 Performance

The visualizer is optimized for smooth performance:

- **Efficient rendering** with minimal redraws using Flutter's setState
- **Memory management** for arrays up to 64 elements
- **Responsive animations** with configurable speeds
- **Input validation** prevents invalid array sizes

## 🔧 Technical Details

### Dependencies

- `flutter/material.dart` - Material Design components
- `dart:math` - Mathematical operations and random generation

### Key Features

- **Single-file architecture** with all UI in main.dart
- **State management** using StatefulWidget with proper lifecycle
- **Animation controller** for pulse effects during sorting
- **Comprehensive validation** for user inputs
- **Auto-correction** for invalid array sizes

### Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 📚 Educational Value

This visualizer is perfect for:

- **Computer Science students** learning sorting algorithms
- **Educators** teaching algorithm concepts with visual aids
- **Developers** reviewing algorithm implementations
- **Algorithm enthusiasts** exploring different sorting approaches

Each algorithm includes detailed educational content explaining complexity, stability, and real-world applications.

## 🐛 Known Issues

- Large arrays (>50 elements) may impact performance on older devices
- Array size input accepts only values between 3-64 (auto-corrected otherwise)
- Animation may pause briefly when switching between algorithms

## 🗺️ Roadmap

- [ ] Add more sorting algorithms (Cocktail Sort, Gnome Sort, etc.)
- [ ] Implement algorithm comparison mode
- [ ] Add custom array input functionality
- [ ] Include performance benchmarking
- [ ] Add keyboard shortcuts for controls

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by various algorithm visualization tools
- VSCode team for the beautiful dark theme
- Flutter community for excellent documentation and examples
- Computer science educators worldwide for algorithm insights

---

**Made with ❤️ using Flutter**

*Educational • Interactive • Beautiful*
