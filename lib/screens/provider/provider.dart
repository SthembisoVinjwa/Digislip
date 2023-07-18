import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  bool _subscribed = true;

  bool get isSubscribed => _subscribed;

  void updateSubscription(bool subscription) {
    _subscribed = subscription;
    notifyListeners();
  }
}
