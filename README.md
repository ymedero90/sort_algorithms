# Sorting Algorithms Visualizer

A beautiful, interactive Flutter application that visualizes various sorting algorithms with real-time step-by-step execution, pseudocode highlighting, and comprehensive algorithm information. Built with a modern MVC architecture and VSCode-inspired dark theme.

![VSCode-inspired dark theme interface](https://img.shields.io/badge/UI-VSCode%20Inspired-007ACC?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVC-28a745?style=flat-square)

## 🌟 Features

### 🎯 Interactive Visualization

- **Real-time array visualization** with color-coded elements
- **Step-by-step execution** with pause/resume functionality
- **Manual step navigation** with previous/next controls in status bar
- **Adjustable animation speed** (0.5x to 3.0x)
- **Responsive design** with collapsible panels
- **Smart input validation** with auto-correction for invalid values

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
- **VSCode-inspired dark theme** with professional color palette
- **Smooth animations** with pulse effects during execution
- **Interactive legends** showing element states
- **Developer info dialog** with professional contact information

### 📝 Educational Content

- **Real-time pseudocode highlighting** synchronized with visualization steps
- **Comprehensive algorithm information** including:
  - Time and space complexity analysis with detailed explanations
  - Stability characteristics with visual indicators
  - Advantages and disadvantages for each algorithm
  - Algorithm-specific implementation details and theory
  - Historical context and practical applications
- **Two-tab interface**: Visualization and Information tabs

### ⚙️ Configuration Options

- **Array size control** (3-64 elements with real-time validation)
- **Algorithm selection** with comprehensive dropdown menu
- **Speed adjustment** with intuitive slider (0.5x to 3.0x)
- **Collapsible panels** for Configuration, Visualization, and Pseudocode sections
- **State persistence** across algorithm changes

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- VS Code or Android Studio (recommended)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/ymedero90/sorting_algorithms.git
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
├── main.dart                      # Application entry point
├── controllers/                   # MVC Controllers
│   ├── sorting_controller.dart    # Main application state controller
│   ├── configuration_controller.dart # Configuration panel controller
│   ├── visualization_controller.dart # Visualization panel controller
│   └── information_controller.dart   # Information panel controller
├── models/
│   ├── sort_step.dart             # Step model for visualization
│   └── sorting_algorithm.dart     # Algorithm interface
├── services/
│   └── sorting_service.dart       # Algorithm execution service
├── theme/
│   └── app_theme.dart             # Centralized theme configuration
├── pages/
│   └── sorting_visualizer_page.dart # Main page with coordinated views
├── widgets/                       # Reusable UI components
│   ├── array_visualizer.dart      # Main visualization widget
│   ├── pseudocode_viewer.dart     # Pseudocode display widget
│   ├── configuration_panel.dart   # Settings and controls panel
│   ├── visualization_panel.dart   # Array and pseudocode display
│   ├── information_panel.dart     # Educational content panel
│   ├── top_bar.dart              # Application header with developer info
│   ├── bottom_status_bar.dart     # Step navigation and status
│   └── developer_info_dialog.dart # Professional developer contact dialog
└── algorithms/                    # Individual algorithm implementations
```

## 🏗️ Architecture

### MVC Pattern Implementation

The application follows a clean MVC (Model-View-Controller) architecture:

#### **Controllers**
- **SortingController**: Main application state and business logic
- **ConfigurationController**: Algorithm selection and parameter configuration
- **VisualizationController**: Array display and animation state
- **InformationController**: Educational content and algorithm details

#### **Models**
- **SortingAlgorithm**: Abstract interface for all sorting algorithms
- **SortStep**: Immutable state representation for each visualization step

#### **Views**
- **Widgets**: Pure presentation components that react to controller state
- **Pages**: Coordinate multiple widgets and controllers

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
  
  // Educational explanations
  String getTimeComplexityExplanation();
  String getSpaceComplexityExplanation();
  String getStabilityExplanation();
  
  List<SortStep> sort(List<int> array);
}
```

### State Management

- **ChangeNotifier**: Controllers use Flutter's built-in state management
- **ListenableBuilder**: Widgets automatically rebuild when state changes
- **Centralized State**: All application state managed through controllers
- **Reactive Architecture**: UI automatically syncs with business logic

## 🎮 How to Use

### Basic Operations

1. **Select an algorithm** from the dropdown menu in Configuration panel
2. **Set array size** (3-64 elements) - values outside this range are auto-corrected
3. **Generate a new array** using the "New Array" button
4. **Start visualization** with the Start/Pause/Resume button
5. **Control playback** with the three action buttons (New Array, Start/Pause, Reset)
6. **Adjust speed** using the speed slider in real-time

### Interface Navigation

- **Configuration Panel**: Algorithm settings and controls (collapsible)
- **Visualization Tab**: Real-time array visualization and synchronized pseudocode
- **Information Tab**: Detailed algorithm analysis and educational content
- **Collapsible Panels**: Click chevron arrows to hide/show sections
- **Status Bar**: Current step counter and manual navigation controls
- **Developer Info**: Click "Developer" in top-right corner for contact information

### Advanced Features

- **Smart Validation**: Input fields automatically correct invalid values
- **State Persistence**: Settings maintained when switching algorithms
- **Professional UI**: VSCode-inspired design with consistent theming
- **Educational Focus**: Comprehensive learning materials for each algorithm

## 🎨 Customization

### Adding New Algorithms

1. Create a new file in `lib/algorithms/`
2. Implement the `SortingAlgorithm` interface
3. Add the algorithm to `SortingService.algorithms` list
4. Include algorithm-specific information in `InformationController`

### Theming

The application uses a centralized VSCode-inspired color scheme in `AppTheme`:

```dart
// Primary colors
static const Color background = Color(0xFF1E1E1E);
static const Color surface = Color(0xFF252526);
static const Color header = Color(0xFF2D2D30);
static const Color primary = Color(0xFF007ACC);
static const Color text = Color(0xFFCCCCCC);
static const Color textSecondary = Color(0xFF858585);

// Algorithm state colors
static const Color normal = Color(0xFF569CD6);
static const Color comparing = Color(0xFFDCDCAA);
static const Color swapping = Color(0xFFF44747);
static const Color sorted = Color(0xFF4EC9B0);
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-algorithm`)
3. Follow the MVC architecture patterns
4. Add comprehensive documentation and tests
5. Ensure UI consistency with existing design
6. Commit your changes (`git commit -am 'Add new sorting algorithm'`)
7. Push to the branch (`git push origin feature/new-algorithm`)
8. Create a Pull Request

### Contribution Guidelines

- **Architecture**: Follow the established MVC pattern
- **Code Style**: Adhere to Dart/Flutter coding standards
- **Documentation**: Include detailed algorithm explanations
- **Testing**: Add unit tests for new controllers and algorithms
- **UI Consistency**: Maintain VSCode-inspired design language

## 📊 Performance

The visualizer is optimized for smooth performance:

- **Efficient State Management**: Controllers minimize unnecessary rebuilds
- **Smart Rendering**: Only affected widgets rebuild on state changes
- **Memory Management**: Optimized for arrays up to 64 elements
- **Responsive Animations**: Configurable speeds with smooth interpolation
- **Input Validation**: Prevents invalid states and crashes

## 🔧 Technical Details

### Dependencies

- `flutter/material.dart` - Material Design components
- `flutter/services.dart` - Clipboard operations for developer info
- `dart:math` - Mathematical operations and random generation

### Key Features

- **MVC Architecture**: Separated concerns with dedicated controllers
- **Reactive State Management**: Automatic UI updates via ChangeNotifier
- **Professional UI**: VSCode-inspired design with developer branding
- **Educational Focus**: Comprehensive algorithm information and explanations
- **Input Validation**: Smart correction of invalid user inputs
- **Asset Management**: Integrated developer avatar and branding

### Supported Platforms

- ✅ Android (Mobile & Tablet)
- ✅ iOS (iPhone & iPad)
- ✅ Web (Desktop browsers)
- ✅ Desktop (Windows, macOS, Linux)

## 📚 Educational Value

This visualizer is perfect for:

- **Computer Science Students**: Learning sorting algorithms with visual feedback
- **Educators**: Teaching algorithm concepts with interactive demonstrations
- **Software Developers**: Reviewing algorithm implementations and complexity
- **Algorithm Enthusiasts**: Exploring different sorting approaches and optimizations

### Educational Features

- **Step-by-Step Breakdown**: Each algorithm step explained with descriptions
- **Complexity Analysis**: Detailed time and space complexity explanations
- **Stability Indicators**: Visual representation of algorithm stability
- **Practical Applications**: Real-world use cases for each algorithm
- **Historical Context**: Background information on algorithm development

## 🐛 Known Issues

- Large arrays (>50 elements) may impact performance on older devices
- Web version may have slight animation delays on slower connections
- Array size input accepts only values between 3-64 (auto-corrected otherwise)

## 🗺️ Roadmap

- [ ] **Algorithm Comparison Mode**: Side-by-side algorithm performance
- [ ] **Custom Array Input**: Allow users to input their own arrays
- [ ] **Performance Benchmarking**: Real-time performance metrics
- [ ] **Sound Effects**: Audio feedback for operations
- [ ] **Export Functionality**: Save visualizations as GIFs/videos
- [ ] **Keyboard Shortcuts**: Hotkeys for common operations
- [ ] **Algorithm Variants**: Different implementations of same algorithms
- [ ] **Mobile Optimizations**: Enhanced mobile/tablet experience

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by various algorithm visualization tools and educational platforms
- VSCode team for the beautiful dark theme that inspired our design
- Flutter community for excellent documentation and development tools
- Computer science educators worldwide for algorithm insights and teaching methods
- Open source contributors who make projects like this possible

## 👨‍💻 Developer

**Yoel Medero Vargas**  
Senior Flutter Developer

Passionate about creating beautiful and functional mobile applications with Flutter. This sorting algorithms visualizer was built to help students and developers understand how different sorting algorithms work through interactive visualization.

### Contact Information

- 📧 **Email**: [ymedero90@gmail.com](mailto:ymedero90@gmail.com)
- 💼 **LinkedIn**: [yoel-medero-vargas](https://www.linkedin.com/in/yoel-medero-vargas-0a661ba7/)
- 🐱 **GitHub**: [ymedero90](https://github.com/ymedero90)

*Click the "Developer" button in the app's top-right corner to view this information interactively!*

---

**Made with ❤️ using Flutter**

*Educational • Interactive • Beautiful • Professional*

⭐ **Star this repository if you found it helpful!**
