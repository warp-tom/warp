import 'dart:async';
import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that triggers whenever a [Stream] emits a new event.
/// Used to wire GoRouter's [refreshListenable] to an auth state stream so the
/// router re-evaluates the redirect function on every auth state change.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
