import 'package:flutter/material.dart';

/// Wraps an onboarding page's content so it can scroll when it doesn't fit
/// the available height (e.g. an iPhone in landscape) instead of
/// overflowing/getting clipped, while looking and behaving exactly as
/// before whenever it already fits -- centered, no scrolling -- which is
/// the normal portrait case.
class OnboardingPageScrollView extends StatelessWidget {
  final Widget child;

  const OnboardingPageScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}
