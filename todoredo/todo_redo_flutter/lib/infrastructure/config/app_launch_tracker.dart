import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks app launches and prompts for a store review after the
/// [_reviewThreshold]th launch, once, ever.
class AppLaunchTracker {
  static const _kLaunchCount = 'launch_count';
  static const _kReviewRequested = 'review_requested';
  static const _reviewThreshold = 7;

  static Future<void> trackLaunchAndMaybeRequestReview() async {
    final prefs = await SharedPreferences.getInstance();
    final launchCount = (prefs.getInt(_kLaunchCount) ?? 0) + 1;
    await prefs.setInt(_kLaunchCount, launchCount);

    final alreadyRequested = prefs.getBool(_kReviewRequested) ?? false;
    if (!alreadyRequested && launchCount >= _reviewThreshold) {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      }
      await prefs.setBool(_kReviewRequested, true);
    }
  }
}
