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
  late List<String> _shuffledNames;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Create a long list with repeated names for smooth animation
    // The list needs to be long enough to cover the entire animation duration
    final extendedList = <String>[];

    // Repeat the shuffled names enough times to fill the animation
    // We want at least 50 items to ensure smooth scrolling even with few members
    final minItems = 50;
    final shuffledBase = List<String>.from(widget.allNames)..shuffle(_random);

    while (extendedList.length < minItems) {
      extendedList.addAll(shuffledBase);
    }

    // Add selected name at the end (this is where animation will stop)
    extendedList.add(widget.selectedName);
    _shuffledNames = extendedList;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a curved animation that starts fast and slows down
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _animation = Tween<double>(
      begin: 0,
      end: (_shuffledNames.length - 1).toDouble(),
    ).animate(curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Wait a bit before calling onComplete
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete();
        });
      }
    });

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
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
            // Slot machine viewport
            Center(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.christmasGreen,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.snowWhite.withValues(alpha: 0.1),
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipRect(
                      child: OverflowBox(
                        minHeight: 0,
                        maxHeight: double.infinity,
                        child: Transform.translate(
                          offset: Offset(0, -_animation.value * 100),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _shuffledNames.map((name) {
                              return SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 32,
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
                        ),
                      ),
                    );
                  },
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
