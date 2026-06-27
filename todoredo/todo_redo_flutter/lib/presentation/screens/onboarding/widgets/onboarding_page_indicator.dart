import 'package:flutter/material.dart';

/// Page indicator widget for onboarding
///
/// Displays dots to indicate current page progress.
class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => _buildDot(context, index),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final isActive = index == currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
