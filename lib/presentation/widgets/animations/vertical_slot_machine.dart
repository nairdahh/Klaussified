import 'dart:math';
import 'package:flutter/material.dart';
import 'package:klaussified/core/theme/colors.dart';

class VerticalSlotMachine extends StatefulWidget {
  final List<String> allNames;
  final String selectedName;
  final VoidCallback onComplete;
  final Duration duration;

  const VerticalSlotMachine({
    super.key,
    required this.allNames,
    required this.selectedName,
    required this.onComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<VerticalSlotMachine> createState() => _VerticalSlotMachineState();
}

class _VerticalSlotMachineState extends State<VerticalSlotMachine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<String> _displayList;
  late double _scrollOffset;
  final Random _random = Random();

  // Animation constants - precise calculations
  static const double itemHeight = 100.0;
  static const double viewportHeight = 400.0; // Container height
  static const double visibleItems = viewportHeight / itemHeight; // 4 items visible

  @override
  void initState() {
    super.initState();

    // Calculate exactly how many items we need
    // CRITICAL: Must work perfectly even with minimum 2 people
    final durationSeconds = widget.duration.inMilliseconds / 1000.0;

    // Calculate items based on REASONABLE scrolling distance
    // We want smooth, visible scrolling - not 32000px!
    final groupSize = widget.allNames.length;

    // Target: scroll through enough items to be dramatic but visible
    // At 100px per item, we want ~50-100 items total for good effect
    // This gives 5000-10000px scroll distance (reasonable for 3 sec animation)
    final int targetScrollItems;
    if (groupSize <= 2) {
      targetScrollItems = 60;  // 60 items = 6000px scroll
    } else if (groupSize <= 4) {
      targetScrollItems = 50;  // 50 items = 5000px scroll
    } else if (groupSize <= 6) {
      targetScrollItems = 45;  // 45 items = 4500px scroll
    } else if (groupSize <= 10) {
      targetScrollItems = 40;  // 40 items = 4000px scroll
    } else {
      targetScrollItems = 35;  // 35 items = 3500px scroll
    }

    final totalScrollItems = targetScrollItems;

    // Build display list with padding to ensure viewport is always full
    final paddingItems = visibleItems.ceil() + 2;
    _displayList = _buildDisplayList(totalScrollItems, paddingItems);

    // Calculate final scroll position - center the selected name in the 400px container
    // Find the LAST occurrence of selected name (the one we added at the end)
    int selectedIndex = -1;
    for (int i = _displayList.length - 1; i >= 0; i--) {
      if (_displayList[i] == widget.selectedName) {
        selectedIndex = i;
        break;
      }
    }

    // Safety check
    if (selectedIndex == -1) {
      selectedIndex = _displayList.length - paddingItems - 1;
    }

    // Center the selected item in the middle of the 400px container (at 200px from top)
    // scrollOffset = (selected item position) - (middle of container) + (half item height to center it)
    _scrollOffset = (selectedIndex * itemHeight) - (viewportHeight / 2) + (itemHeight / 2);

    // Ensure we don't scroll beyond the list boundaries
    final maxScroll = (_displayList.length * itemHeight) - viewportHeight;
    _scrollOffset = _scrollOffset.clamp(0.0, maxScroll);

    print('DEBUG ROULETTE: groupSize=$groupSize, targetItems=$targetScrollItems, totalItems=${_displayList.length}');
    print('DEBUG ROULETTE: selectedIndex=$selectedIndex, scrollOffset=$_scrollOffset');

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Smooth acceleration and deceleration curve
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    );

    _animation = Tween<double>(
      begin: 0,
      end: _scrollOffset,
    ).animate(curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });

    // Start animation after brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  List<String> _buildDisplayList(int scrollItems, int padding) {
    final result = <String>[];
    final shuffledNames = List<String>.from(widget.allNames)..shuffle(_random);

    // Add padding items at start (so viewport is full from the beginning)
    for (int i = 0; i < padding; i++) {
      result.add(shuffledNames[i % shuffledNames.length]);
    }

    // Add main scrolling items (shuffled repeatedly)
    int addedItems = 0;
    while (addedItems < scrollItems) {
      final batch = List<String>.from(shuffledNames)..shuffle(_random);
      result.addAll(batch);
      addedItems += batch.length;
    }

    // Add selected name (where we stop)
    result.add(widget.selectedName);

    // Add padding items at end (so viewport stays full at the end)
    for (int i = 0; i < padding; i++) {
      result.add(shuffledNames[i % shuffledNames.length]);
    }

    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.christmasRed,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Scrolling names - use full container height
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: Column(
                    children: _displayList.map((name) {
                      return SizedBox(
                        height: itemHeight,
                        child: Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.snowWhite,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Selection indicator box - centered
            Center(
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.christmasGreen,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.snowWhite.withValues(alpha: 0.1),
                ),
              ),
            ),

            // Top gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 140,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.christmasRed,
                      AppColors.christmasRed.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 140,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.christmasRed,
                      AppColors.christmasRed.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative elements
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard,
                    color: AppColors.snowWhite.withValues(alpha: 0.8),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Secret Santa',
                    style: TextStyle(
                      color: AppColors.snowWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.card_giftcard,
                    color: AppColors.snowWhite.withValues(alpha: 0.8),
                    size: 32,
                  ),
                ],
              ),
            ),

            // Bottom text
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                'Drawing your Secret Santa...',
                style: TextStyle(
                  color: AppColors.snowWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
