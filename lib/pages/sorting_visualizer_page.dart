import 'package:flutter/material.dart';
import 'package:sort_algorithms/widgets/developer_info_dialog.dart';
import 'package:sort_algorithms/widgets/mobile_bottom_controls.dart';
import 'package:sort_algorithms/widgets/mobile_configuration_panel.dart';
import 'package:sort_algorithms/widgets/mobile_visualization_panel.dart';

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

  // Control de animación
  bool _isAnimationRunning = false;

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
    if (_sortingController.isPlaying && !_isAnimationRunning) {
      _pulseController.repeat();
      _runAnimation();
    } else if (!_sortingController.isPlaying) {
      _pulseController.stop();
      _isAnimationRunning = false;
    }
  }

  void _runAnimation() async {
    if (_isAnimationRunning) return; // Prevenir múltiples animaciones

    _isAnimationRunning = true;

    while (_sortingController.isPlaying && _isAnimationRunning && mounted) {
      // Calcular delay basado en la velocidad
      int delayMs = (1500 / _sortingController.animationSpeed).round().clamp(100, 3000);

      // Esperar el delay completo antes de continuar
      await Future.delayed(Duration(milliseconds: delayMs));

      // Verificar si aún estamos en modo reproducción y montados
      if (_sortingController.isPlaying && _isAnimationRunning && mounted) {
        await _sortingController.executeAnimationStep();
      } else {
        break;
      }
    }

    _isAnimationRunning = false;
  }

  @override
  void dispose() {
    _isAnimationRunning = false;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          if (isMobile) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
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
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(56), child: _buildMobileAppBar()),
      body: Column(
        children: [
          _buildMobileTabBar(),
          Expanded(
            child: ListenableBuilder(
              listenable: _sortingController,
              builder: (context, child) {
                // Mapear índices de móvil a contenido correcto
                Widget currentWidget;
                switch (_sortingController.activeTabIndex) {
                  case 0: // Visualization
                    currentWidget = ListenableBuilder(
                      listenable: _visualizationController,
                      builder:
                          (context, child) => MobileVisualizationPanel(
                            controller: _visualizationController,
                            pulseController: _pulseController,
                          ),
                    );
                    break;
                  case 1: // Information
                    currentWidget = ListenableBuilder(
                      listenable: _informationController,
                      builder: (context, child) => InformationPanel(controller: _informationController),
                    );
                    break;
                  case 2: // Settings
                    currentWidget = ListenableBuilder(
                      listenable: _configController,
                      builder: (context, child) => MobileConfigurationPanel(controller: _configController),
                    );
                    break;
                  default:
                    currentWidget = ListenableBuilder(
                      listenable: _visualizationController,
                      builder:
                          (context, child) => MobileVisualizationPanel(
                            controller: _visualizationController,
                            pulseController: _pulseController,
                          ),
                    );
                }
                return currentWidget;
              },
            ),
          ),
          ListenableBuilder(
            listenable: _sortingController,
            builder:
                (context, child) => MobileBottomControls(
                  currentStep: _sortingController.currentStepIndex + 1,
                  totalSteps: _sortingController.steps.length,
                  canGoPrevious: _sortingController.canGoPrevious,
                  canGoNext: _sortingController.canGoNext,
                  onPrevious: _sortingController.previousStep,
                  onNext: _sortingController.nextStep,
                  configController: _configController,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppTheme.header,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.sort, color: AppTheme.primary, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Sorting Visualizer',
              style: TextStyle(color: AppTheme.text, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: AppTheme.textSecondary),
          onPressed: () => _showDeveloperInfo(context),
        ),
      ],
    );
  }

  Widget _buildMobileTab(String title, int index, IconData icon) {
    return ListenableBuilder(
      listenable: _sortingController,
      builder: (context, child) {
        final isActive = _sortingController.activeTabIndex == index;
        return Expanded(
          child: InkWell(
            onTap: () {
              print('📱 Tapping mobile tab $index'); // Debug
              _sortingController.setMobileTab(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isActive ? AppTheme.background : AppTheme.surface,
                border: Border(bottom: BorderSide(color: isActive ? AppTheme.primary : Colors.transparent, width: 2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: isActive ? AppTheme.primary : AppTheme.textSecondary, size: 20),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? AppTheme.text : AppTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileTabBar() {
    return ListenableBuilder(
      listenable: _sortingController,
      builder: (context, child) {
        return Container(
          height: 48,
          color: AppTheme.surface,
          child: Row(
            children: [
              _buildMobileTab('Visualization', 0, Icons.bar_chart),
              _buildMobileTab('Information', 1, Icons.info),
              _buildMobileTab('Settings', 2, Icons.settings),
            ],
          ),
        );
      },
    );
  }

  void _showDeveloperInfo(BuildContext context) {
    showDialog(context: context, builder: (context) => const DeveloperInfoDialog());
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
