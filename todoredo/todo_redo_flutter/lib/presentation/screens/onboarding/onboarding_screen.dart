import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_page.dart';
import 'pages/permissions_info_page.dart';
import 'pages/permissions_request_page.dart';
import 'pages/completion_page.dart';
import 'widgets/onboarding_page_indicator.dart';

/// Onboarding wizard screen
///
/// Displays a multi-page wizard for first-time users.
/// Covers welcome, permissions explanation, permissions request, and completion.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      // Navigate to main app
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _showSkipDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Onboarding?'),
        content: const Text(
          'You can still grant permissions later in your device settings if needed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Skip'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Show skip button except on last page
          if (_currentPage < _totalPages - 1)
            TextButton(
              onPressed: _showSkipDialog,
              child: const Text('Skip'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OnboardingPageIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                WelcomePage(onNext: _nextPage),
                PermissionsInfoPage(onNext: _nextPage),
                PermissionsRequestPage(onNext: _nextPage),
                CompletionPage(onComplete: _completeOnboarding),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                if (_currentPage > 0)
                  TextButton.icon(
                    onPressed: _previousPage,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  )
                else
                  const SizedBox(width: 100),

                // Next button (hidden on last page, handled by completion page)
                if (_currentPage < _totalPages - 1)
                  ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  )
                else
                  const SizedBox(width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
