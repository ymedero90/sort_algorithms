import 'package:flutter/material.dart';

import '../controllers/configuration_controller.dart';
import '../controllers/information_controller.dart';
import '../controllers/sorting_controller.dart';
import '../controllers/visualization_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_status_bar.dart';
import '../widgets/configuration_panel.dart';
import '../widgets/information_panel.dart';
import '../widgets/top_bar.dart';
import '../widgets/visualization_panel.dart';

class SortingVisualizerPage extends StatefulWidget {
  const SortingVisualizerPage({super.key});

  @override
  State<SortingVisualizerPage> createState() => _SortingVisualizerPageState();
}

class _SortingVisualizerPageState extends State<SortingVisualizerPage> with TickerProviderStateMixin {
  late SortingController _sortingController;
  late ConfigurationController _configController;
  late VisualizationController _visualizationController;
  late InformationController _informationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores
    _sortingController = SortingController();
    _configController = ConfigurationController(_sortingController);
    _visualizationController = VisualizationController(_sortingController);
    _informationController = InformationController(_sortingController);

    // Inicializar animación
    _pulseController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    // Inicializar datos
    _sortingController.initialize();

    // Escuchar cambios para controlar la animación
    _sortingController.addListener(_onAnimationStateChanged);
  }

  void _onAnimationStateChanged() {
    if (_sortingController.isPlaying) {
      _pulseController.repeat();
      _runAnimation();
    } else {
      _pulseController.stop();
    }
  }

  void _runAnimation() async {
    while (_sortingController.isPlaying) {
      await Future.delayed(Duration(milliseconds: (1000 / _sortingController.animationSpeed).round()));

      if (_sortingController.isPlaying) {
        await _sortingController.executeAnimationStep();
      }
    }
  }

  @override
  void dispose() {
    _sortingController.removeListener(_onAnimationStateChanged);
    _pulseController.dispose();
    _configController.dispose();
    _visualizationController.dispose();
    _informationController.dispose();
    _sortingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const TopBar(),
          Expanded(
            child: Row(
              children: [
                ListenableBuilder(
                  listenable: _configController,
                  builder: (context, child) => ConfigurationPanel(controller: _configController),
                ),
                Container(width: 1, color: AppTheme.divider),
                Expanded(
                  child: Column(
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: ListenableBuilder(
                          listenable: _sortingController,
                          builder:
                              (context, child) => IndexedStack(
                                index: _sortingController.activeTabIndex,
                                children: [
                                  ListenableBuilder(
                                    listenable: _visualizationController,
                                    builder:
                                        (context, child) => VisualizationPanel(
                                          controller: _visualizationController,
                                          pulseController: _pulseController,
                                        ),
                                  ),
                                  ListenableBuilder(
                                    listenable: _informationController,
                                    builder: (context, child) => InformationPanel(controller: _informationController),
                                  ),
                                ],
                              ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: _sortingController,
                        builder:
                            (context, child) => BottomStatusBar(
                              currentStep: _sortingController.currentStepIndex + 1,
                              totalSteps: _sortingController.steps.length,
                              canGoPrevious: _sortingController.canGoPrevious,
                              canGoNext: _sortingController.canGoNext,
                              onPrevious: _sortingController.previousStep,
                              onNext: _sortingController.nextStep,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return ListenableBuilder(
      listenable: _sortingController,
      builder:
          (context, child) => Container(
            height: 35,
            color: AppTheme.header,
            child: Row(children: [_buildTab('Visualization', 0), _buildTab('Information', 1)]),
          ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _sortingController.activeTabIndex == index;
    return InkWell(
      onTap: () => _sortingController.setActiveTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.background : AppTheme.header,
          border: Border(bottom: BorderSide(color: isActive ? AppTheme.primary : Colors.transparent, width: 2)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? AppTheme.text : AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
