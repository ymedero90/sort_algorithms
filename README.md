# 🎯 Sorting Algorithms Visualizer

An interactive educational tool for visualizing and understanding how different sorting algorithms work step-by-step. Built with Flutter for both desktop and mobile platforms.

## ✨ Features

### 📊 Interactive Visualization

- **Real-time step-by-step animation** with adjustable speed control (0.1x to 2.0x)
- **Color-coded elements** showing different states (normal, comparing, swapping, sorted)
- **Detailed action history** with chronological algorithm steps
- **Interactive pseudocode** with line-by-line highlighting
- **Responsive design** optimized for desktop and mobile devices

### 🔧 Comprehensive Algorithm Support

Currently supports **12 sorting algorithms** across different categories:

#### Comparison-Based Algorithms

- **Bubble Sort** - Simple with early termination optimization
- **Selection Sort** - Minimum swaps approach  
- **Insertion Sort** - Builds sorted array incrementally
- **Shell Sort** - Gap-based improvement of insertion sort
- **Quick Sort** - Divide-and-conquer with pivot partitioning
- **Merge Sort** - Stable divide-and-conquer approach
- **Heap Sort** - Uses binary heap data structure
- **Tim Sort** - Hybrid merge sort + insertion sort (Python/Java standard)

#### Non-Comparison Algorithms

- **Counting Sort** - Integer sorting by occurrence counting
- **Radix Sort** - Digit-by-digit sorting using counting sort
- **Bucket Sort** - Distributes elements into sorted buckets

#### Specialized Algorithms

- **Bitonic Sort** - Parallel sorting for power-of-2 arrays

### 📚 Educational Content

- **Comprehensive algorithm information** with detailed explanations
- **Complexity analysis** covering time, space, and stability
- **Advantages and disadvantages** for each algorithm
- **Use case recommendations** and practical insights
- **Interactive pseudocode** synchronized with visualization

### 📱 Cross-Platform Experience

#### Desktop Features

- **Dual-panel layout** with visualization and pseudocode
- **Collapsible panels** for focused learning
- **Full configuration sidebar** with all controls
- **Detailed step navigation** with status bar

#### Mobile Features  

- **Three-tab interface**: Visualization, Information, Settings
- **Touch-optimized controls** with larger buttons
- **Compact visualization** adapted for small screens
- **Bottom control panel** with essential functions

## 📖 How to Use

### Getting Started

1. **Select Algorithm**: Choose from 12 different sorting algorithms
2. **Configure Array**: Set size (3-64 elements) and generate random data
3. **Adjust Speed**: Control animation speed for optimal learning pace
4. **Start Visualization**: Watch step-by-step algorithm execution
5. **Explore Details**: Switch to Information tab for in-depth analysis

### Understanding the Visualization

**Color States:**

- 🔵 **Normal (Blue)**: Elements in current position
- 🟡 **Comparing (Yellow)**: Elements being compared
- 🔴 **Swapping (Red)**: Elements being moved/swapped
- 🟢 **Sorted (Green)**: Elements in final sorted position

**Interactive Features:**

- **Action History**: See chronological log of algorithm operations
- **Pseudocode Tracking**: Follow highlighted code execution
- **Manual Navigation**: Step forward/backward through the process
- **Speed Control**: Adjust from very slow (0.1x) to fast (2.0x)

## 🚀 Installation & Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/ymedero90/sorting-algorithms-visualizer.git
cd sorting-algorithms-visualizer

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## 📊 Algorithm Comparison

| Algorithm | Time Complexity | Space | Stable | Best Use Case |
|-----------|----------------|-------|--------|---------------|
| **Bubble Sort** | O(n²) | O(1) | ✅ | Education, small arrays |
| **Selection Sort** | O(n²) | O(1) | ❌ | Memory-constrained systems |
| **Insertion Sort** | O(n²) | O(1) | ✅ | Small/nearly sorted arrays |
| **Shell Sort** | O(n log²n) | O(1) | ❌ | Medium-sized arrays |
| **Quick Sort** | O(n log n) avg | O(log n) | ❌ | General purpose, large arrays |
| **Merge Sort** | O(n log n) | O(n) | ✅ | Stable sorting, linked lists |
| **Heap Sort** | O(n log n) | O(1) | ❌ | Guaranteed performance |
| **Tim Sort** | O(n log n) | O(n) | ✅ | Real-world data patterns |
| **Counting Sort** | O(n+k) | O(k) | ✅ | Small integer ranges |
| **Radix Sort** | O(d×n) | O(n) | ✅ | Fixed-length integers |
| **Bucket Sort** | O(n+k) avg | O(n) | ✅ | Uniformly distributed data |
| **Bitonic Sort** | O(n log²n) | O(log n) | ❌ | Parallel processing |

## 🎓 Educational Objectives

Students will learn:

1. **Algorithm Mechanics**: How each sorting method works internally
2. **Performance Trade-offs**: Time vs space vs stability considerations  
3. **Practical Applications**: When to use each algorithm in real scenarios
4. **Complexity Analysis**: Understanding Big O notation through examples
5. **Implementation Patterns**: Common computer science techniques

## 🛠️ Technical Architecture

### Core Components

- **SortingController**: Central state management and algorithm execution
- **VisualizationController**: Handles display state and animations  
- **ConfigurationController**: Manages user settings and inputs
- **InformationController**: Provides educational content

### Key Features

- **Responsive Design**: Adaptive layouts for different screen sizes
- **Smooth Animations**: 60fps transitions with Flutter's AnimationController
- **Modular Architecture**: Easy to extend with new algorithms
- **Educational Focus**: Step-by-step learning with detailed explanations

## 🤝 Contributing

We welcome contributions! Areas for enhancement:

- **New Algorithms**: Add more sorting methods (Cocktail Sort, Gnome Sort, etc.)
- **Enhanced Visualizations**: Improve animations and visual feedback
- **Educational Content**: Expand explanations and add more examples  
- **Performance**: Optimize for larger datasets
- **Accessibility**: Add screen reader support and keyboard navigation

## 👨‍💻 Developer

**Yoel Medero Vargas**  
Senior Flutter Developer

- 📧 **Email**: <ymedero90@gmail.com>
- 💼 **LinkedIn**: [linkedin.com/in/yoel-medero-vargas-0a661ba7/](https://www.linkedin.com/in/yoel-medero-vargas-0a661ba7/)
- 🐙 **GitHub**: [github.com/ymedero90](https://github.com/ymedero90)

*Passionate about creating educational tools that make complex computer science concepts accessible through interactive visualization.*

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Computer science educators for inspiration  
- The global developer community for continuous learning

---

*Built with ❤️ and Flutter to make sorting algorithms accessible to everyone*
